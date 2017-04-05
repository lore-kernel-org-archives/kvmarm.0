From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Wed, 5 Apr 2017 13:37:10 +0200
Message-ID: <91ab3b0b-c30e-7a19-f60f-882d26388ef5@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com> <20170404160417.GN11752@cbox>
 <20170404175718.su4tjx3psyez3qee@kamzik.brq.redhat.com>
 <20170404190438.GF31208@cbox>
 <63209d09-0c45-0bb2-322b-e422f1360df7@redhat.com>
 <20170405070959.GA1526@cbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------2522F0A76704302EC23692F6"
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99E8240B5B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 07:35:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZO4D5vTxe9Lc for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Apr 2017 07:35:02 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 191E540A66
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 07:35:01 -0400 (EDT)
In-Reply-To: <20170405070959.GA1526@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This is a multi-part message in MIME format.
--------------2522F0A76704302EC23692F6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit



On 05/04/2017 09:09, Christoffer Dall wrote:
>>>  - In the explanation you wrote, you use the term 'we' a lot, but when
>>>    talking about SMP barriers, I think it only makes sense to talk about
>>>    actions and observations between multiple CPUs and we have to be
>>>    specific about which CPU observes or does what with respect to the
>>>    other.  Maybe I'm being a stickler here, but there something here
>>>    which is making me uneasy.
>> The write1-mb-if(read2) / write2-mb-if(read1) pattern is pretty common,
>> so I think it is justified to cut the ordering on the reasoning and just
>> focus on what the two memory locations and conditions mean.
> ok, but the pattern above was not common to me (and I'm pretty sure I'm
> not the only fool in the bunch here), so if we can reference something
> that explains that this is a known pattern which has been tried and
> proven, that would be even better.

I found https://lwn.net/Articles/573436/ which shows this example:

  CPU 0					CPU 1
  ---------------------			----------------------
  WRITE_ONCE(x, 1);			WRITE_ONCE(y, 1);
  smp_mb();				smp_mb();
  r2 = READ_ONCE(y);			r4 = READ_ONCE(x);

And says that it is a bug if r2 == 0 && r4 == 0.  This is exactly what 
happens in KVM:

  CPU 0					CPU 1
  ---------------------			----------------------
  vcpu->mode = IN_GUEST_MODE;		kvm_make_request(REQ, vcpu);
  smp_mb();				smp_mb();
  r2 = kvm_request_pending(vcpu)	r4 = (vcpu->mode == IN_GUEST_MODE)
  if (r2)				if (r4)
	abort entry				kick();

If r2 sees no request and r4 doesn't kick there would be a bug.
But why can't this happen?

- if no request is pending at the time of the read to r2, CPU 1 must
not have executed kvm_make_request yet.  In CPU 0, kvm_request_pending
must happen after vcpu->mode is set to IN_GUEST_MODE, therefore CPU 1
will read IN_GUEST_MODE and kick.

- if no kick happens in CPU 1, CPU 0 must not have set vcpu->mode yet.
In CPU 1, vcpu->mode is read after setting the request bit, therefore
CPU 0 will see the request bit and abort the guest entry.

>>>  - Finally, it feels very hard to prove the correctness of this, and
>>>    equally hard to test it (given how long we've been running with
>>>    apparently racy code).  I would hope that we could abstract some of
>>>    this into architecture generic things, that someone who eat memory
>>>    barriers for breakfast could help us verify, but again, maybe this is
>>>    Radim's series I'm asking for here.
>>
>> What I can do here is to suggest copying the paradigms from x86, which
>> is quite battle tested (Windows hammers it really hard).
>
> That sounds reasonable, but I think part of the problem was that we
> simply didn't understand what the paradigms were (see the
> kvm_make_all_cpus_request above as an example), so Drew's action about
> documenting what this all is and the constraints of using it is really
> important for me to do that.

Yes, totally agreed on that.

>> For QEMU I did use model checking in the past for some similarly hairy
>> synchronization code, but that is really just "executable documentation"
>> because the model is not written in C.
>>
> I played with using blast on some of the KVM/ARM code a long time ago,
> and while I was able to find a bug with it, it was sort of an obvious
> bug, and the things I was able to do with it was pretty limited to the
> problems I could imagine myself anyhow.  Perhaps this is what you mean
> with executable documentation.

I prepared three examples of a spin model for KVM vCPU kicking, and
the outcome was actually pretty surprising: the mode check seems not
to be necessary.

I haven't covered all x86 cases so I'm not going to remove it right
ahead, but for ARM it really seems like EXITING_GUEST_MODE is nothing
but an optimization of consecutive kvm_vcpu_kicks.

All three models can use C preprocessor #defines to inject bugs:

- kvm-arm-pause.promela: the "paused" mechanism; the model proves that
  the "paused" test in the interrupt-disabled region is necessary

- kvm-req.promela: the requests mechanism; the model proves that
  the requests check in the interrupt-disabled region is necessary

- kvm-x86-pi.promela: the x86 posted interrupt mechanism (simplified
  a bit); the model proves that KVM must disable interrupts before
  checking for interrupts injected while outside guest mode
  (commit b95234c84004, "kvm: x86: do not use KVM_REQ_EVENT for APICv
  interrupt injection", 2017-02-15)

So it seems like there are no races after all in KVM/ARM code, though
the code can still be cleaned up.  And I have been convinced of the wrong
thing all the time. :)

But why is KVM/ARM using KVM_REQ_VCPU_EXIT
just fine without checking for requests (kvm-req.promela)?  Because,
as mentioned earlier in the thread, KVM/ARM is using kvm_make_all_vcpus_request
simply to kick all VCPUs.  The paused variable _is_ checked after disabling
interrupts, and that is fine.

After this experiment, I think I like Drew's KVM_REQ_PAUSE more than I did
yesterday.  However, yet another alternative is to leave pause/power_off as
they are, while taking some inspiration from his patch to do some cleanups:

1) change the "if"

                if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
                        vcpu->arch.power_off || vcpu->arch.pause) {

to test kvm_requests_pending instead of pause/power_off

2) clear KVM_REQ_VCPU_EXIT before the other "if":

                if (vcpu->arch.power_off || vcpu->arch.pause)
                        vcpu_sleep(vcpu);


In any case, the no-wakeup behavior of kvm_make_all_vcpus_request suits
either use of requests (KVM_REQ_PAUSE or "fixed" KVM_REQ_VCPU_EXIT).

Paolo

--------------2522F0A76704302EC23692F6
Content-Type: text/plain; charset=UTF-8;
 name="kvm-arm-pause.promela"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="kvm-arm-pause.promela"

/* To run the model checker:
 *
 *      spin -a kvm-arm-pause.promela
 *      gcc -O2 pan.c
 *      ./a.out -a -f
 *
 * Remove the tests using -DREMOVE_MODE_TEST, -DREMOVE_PAUSED_TEST
 * right after -a.  The mode test is not necessary, the paused test is.
 */
#define OUTSIDE_GUEST_MODE      0
#define IN_GUEST_MODE           1
#define EXITING_GUEST_MODE      2

bool kick;
bool paused;
int vcpu_mode =3D OUTSIDE_GUEST_MODE;

active proctype vcpu_run()
{
    do
        :: true -> {
            /* In paused state, sleep with interrupts on */
            if
                :: !paused -> skip;
            fi;

            /* IPIs are eaten until interrupts are turned off.  */
            kick =3D 0;

            /* Interrupts are now off. */
            vcpu_mode =3D IN_GUEST_MODE;

            if
#ifndef REMOVE_MODE_TEST
                :: vcpu_mode !=3D IN_GUEST_MODE -> skip;
#endif
#ifndef REMOVE_PAUSED_TEST
                :: paused -> skip;
#endif
                :: else -> {
                    do
                        /* Stay in guest mode until an IPI comes */
                        :: kick -> break;
                    od;
                }
            fi;
            vcpu_mode =3D OUTSIDE_GUEST_MODE;

            /* Turn on interrupts */
        }
    od
}

active proctype vcpu_kick()
{
    int old;

    do
        :: true -> {
            paused =3D 1;
            /* cmpxchg */
            atomic {
                old =3D vcpu_mode;
                if
                    :: vcpu_mode =3D=3D IN_GUEST_MODE ->
                        vcpu_mode =3D EXITING_GUEST_MODE;
                    :: else -> skip;
                fi;
            }

            if
                :: old =3D=3D IN_GUEST_MODE -> kick =3D 1;
                :: else -> skip;
            fi;

            if
               :: vcpu_mode =3D=3D OUTSIDE_GUEST_MODE -> paused =3D 0;
            fi;=20
        }
    od;
}

never {
    do
       /* After an arbitrarily long prefix */
       :: 1 -> skip;

       /* if we get a pause request */
       :: paused -> break;
    od;=20

accept:
    /* we must eventually leave guest mode (this condition is reversed!) =
*/
    do
       :: vcpu_mode !=3D OUTSIDE_GUEST_MODE
    od;=20
}

--------------2522F0A76704302EC23692F6
Content-Type: text/plain; charset=UTF-8;
 name="kvm-req.promela"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="kvm-req.promela"

/* To run the model checker:
 *
 *      spin -a kvm-req.promela
 *      gcc -O2 pan.c
 *      ./a.out -a -f
 *
 * Remove the tests using -DREMOVE_MODE_TEST, -DREMOVE_REQ_TEST
 * right after -a.  The mode test is not necessary, the vcpu_req test is.=

 */
#define OUTSIDE_GUEST_MODE      0
#define IN_GUEST_MODE           1
#define EXITING_GUEST_MODE      2

bool kick;
int vcpu_req;
int vcpu_mode =3D OUTSIDE_GUEST_MODE;

active proctype vcpu_run()
{
    do
        :: true -> {
            /* Requests are processed with interrupts on */
            vcpu_req =3D 0;

            /* IPIs are eaten until interrupts are turned off.  */
            kick =3D 0;

            /* Interrupts are now off. */
            vcpu_mode =3D IN_GUEST_MODE;

            if
#ifndef REMOVE_MODE_TEST
                :: vcpu_mode !=3D IN_GUEST_MODE -> skip;
#endif
#ifndef REMOVE_REQ_TEST
                :: vcpu_req -> skip;
#endif
                :: else -> {
                    do
                        /* Stay in guest mode until an IPI comes */
                        :: kick -> break;
                    od;
                }
            fi;
            vcpu_mode =3D OUTSIDE_GUEST_MODE;

            /* Turn on interrupts */
        }
    od
}

active proctype vcpu_kick()
{
    int old;

    do
        :: true -> {
            vcpu_req =3D 1;
            if
                :: old =3D=3D 0 -> {
                    /* cmpxchg */
                    atomic {
                        old =3D vcpu_mode;
                        if
                            :: vcpu_mode =3D=3D IN_GUEST_MODE ->
                                vcpu_mode =3D EXITING_GUEST_MODE;
                            :: else -> skip;
                        fi;
                    }

                    if
                        :: old =3D=3D IN_GUEST_MODE -> kick =3D 1;
                        :: else -> skip;
                    fi;
                }
                :: else -> skip;
            fi;
        }
    od;
}

never {
    do
       /* After an arbitrarily long prefix */
       :: 1 -> skip;

       /* we get in guest mode */
       :: vcpu_mode =3D=3D IN_GUEST_MODE -> break;
    od;=20

accept:
    /* and never leave it (this condition is reversed!) */
    do
       :: vcpu_mode !=3D OUTSIDE_GUEST_MODE
    od;=20
}

--------------2522F0A76704302EC23692F6
Content-Type: text/plain; charset=UTF-8;
 name="kvm-x86-pi.promela"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="kvm-x86-pi.promela"

/* To run the model checker:
 *
 *      spin -a kvm-x86-pi.promela
 *      gcc -O2 pan.c
 *      ./a.out -a -f
 *
 * Remove the test using -DREMOVE_MODE_TEST, move the PIR->IRR sync
 * before local_irq_disable() with SYNC_WITH_INTERRUPTS_ENABLED.  The
 * mode test is not necessary, while sync_pir_to_irr must be placed
 * after interrupts are disabled.
 */
#define OUTSIDE_GUEST_MODE      0
#define IN_GUEST_MODE           1
#define EXITING_GUEST_MODE      2

bool kick;
bool posted_interrupt;
int vcpu_pir;
int vcpu_mode =3D OUTSIDE_GUEST_MODE;

active proctype vcpu_run()
{
    do
        :: true -> {
#ifdef SYNC_WITH_INTERRUPTS_ENABLED
            /* Guest interrupts are injected with interrupts off */
            vcpu_pir =3D 0;
#endif

            /* Both kinds of IPI are eaten until interrupts are turned of=
f.  */
            atomic {
                kick =3D 0;
                posted_interrupt =3D 0;
            }

            /* Interrupts are now off. */
            vcpu_mode =3D IN_GUEST_MODE;

#ifndef SYNC_WITH_INTERRUPTS_ENABLED
            /* Guest interrupts are injected with interrupts off */
            vcpu_pir =3D 0;
#endif

            if
#ifndef REMOVE_MODE_TEST
                :: vcpu_mode !=3D IN_GUEST_MODE -> skip;
#endif

                :: else -> {
                    do
                        /* Stay in guest mode until an IPI comes */
                        :: kick -> break;

                        /* The processor handles the posted interrupt IPI=
 */
                        :: posted_interrupt -> vcpu_pir =3D 0;
                    od;
                }
            fi;
            vcpu_mode =3D OUTSIDE_GUEST_MODE;

            /* Turn on interrupts */
        }
    od
}

active proctype vcpu_posted_interrupt()
{
    int old;

    do
        :: vcpu_pir =3D=3D 0 -> {
            vcpu_pir =3D 1;
            if
                :: vcpu_mode =3D=3D IN_GUEST_MODE ->
                    /* If in guest mode, we can send a posted interrupt I=
PI */
                    posted_interrupt =3D 1;

                :: else -> {
                    /* Else, do a kvm_vcpu_kick.  */
                    atomic {
                        old =3D vcpu_mode;
                        if
                            :: vcpu_mode =3D=3D IN_GUEST_MODE ->
                                vcpu_mode =3D EXITING_GUEST_MODE;
                            :: else -> skip;
                        fi;
                    }

                    if
                        :: old =3D=3D IN_GUEST_MODE -> kick =3D 1;
                        :: else -> skip;
                    fi;
                }
            fi;
        }
    od;
}

never {
    do
       /* After an arbitrarily long prefix */
       :: 1 -> skip;

       /* if we get an interrupt */
       :: vcpu_pir -> break;
    od;=20

accept:
    /* we must eventually inject it (this condition is reversed!) */
    do
       :: vcpu_pir
    od;=20
}

--------------2522F0A76704302EC23692F6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--------------2522F0A76704302EC23692F6--
