Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15281101
	for <kvmarm@lists.linux.dev>; Fri,  5 May 2023 18:32:49 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-3f1738d0d4cso14317765e9.1
        for <kvmarm@lists.linux.dev>; Fri, 05 May 2023 11:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683311568; x=1685903568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ac19JG48GBtPijCyis/lUlGpHSzEFMUT5J3j3a0mlDw=;
        b=2Vjn/E/QMQfZJrDnRbXa8o2vfPuQcAFLHdsDfgaA08kaBYWlsQdPorip9ij2ge2oZQ
         Z/91osG3K+TlDAVN3renMq1XagAfy80Lv3DIWF05ypxAfaFmuktovC/Movhv5orvIptv
         /e74kvI1W81NHvIKFJhSQQ8XTYMgyzE4b4x0ZPaSbj2YohCNPqLkwBOamYkecwPlJCZZ
         EZn3NaIeRw9NuLmVSEM83++z632mLuCbkwH2PfwbEy5N4+bST7H/9nrTGE9KnTC3WC29
         QFjEMlmn0PPcDHLsCdcbjfiYdDu6ebiUr8dazhIRnYfXk/PJU8D0mY3083viB/UOF8kT
         +8rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683311568; x=1685903568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ac19JG48GBtPijCyis/lUlGpHSzEFMUT5J3j3a0mlDw=;
        b=eZ+DXrjz+AD1ciourQgji+hMNrcgkpdl070tpn4/Yt2bCMxxDU9/7cVm1a8aadb9ez
         YzjDRHr2Cd79W0kb7earRRhnBRz3gSzMVi0lAwUY4XmXKU2vOww5yt4Mo2BLnBrMhGUl
         JDVOlWkOUmQdK3UprpNz0ALw0amoZULYnDSbKe0rQ/tPPayGm5kiz2nZ8+G55gKKcDIF
         12rFGKghqVxCiorjnAt6+9CBMw6l0psG8k8sUXK7/89+Mdg532vNdi0QdL36zD8/ur9Q
         BS6XknmNyY0wa1HzfE+j7dIDvS/kli0TdzNs2lLGTdmZWoPvsWl6EO/Xde9mciZiqihI
         H2Zg==
X-Gm-Message-State: AC+VfDxdNm2mtSc8yQp3G0HIoc0ACAiU/+w/tgtDgll7ZvQz+Zl2CB4p
	BFQkVBr/mFOQqYIu30MpxYFB3AwbMuf5mxcH0CJHzg==
X-Google-Smtp-Source: ACHHUZ70m4C9GHYCR04TFu22eAoIwG550xIifoZqMwMnLJz2A9H4v7hyYdzNReiPkO9I/E6NglAQcNxA8LXjgwBBY8Y=
X-Received: by 2002:adf:da48:0:b0:304:97b3:d5a0 with SMTP id
 r8-20020adfda48000000b0030497b3d5a0mr1859897wrl.27.1683311567628; Fri, 05 May
 2023 11:32:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com> <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n> <ZFQC5TZ9tVSvxFWt@x1n>
In-Reply-To: <ZFQC5TZ9tVSvxFWt@x1n>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 5 May 2023 11:32:11 -0700
Message-ID: <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Nadav Amit <nadav.amit@gmail.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org, 
	oliver.upton@linux.dev, James Houghton <jthoughton@google.com>, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 4, 2023 at 12:09=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, May 03, 2023 at 07:45:28PM -0400, Peter Xu wrote:
> > On Wed, May 03, 2023 at 02:42:35PM -0700, Sean Christopherson wrote:
> > > On Wed, May 03, 2023, Peter Xu wrote:
> > > > Oops, bounced back from the list..
> > > >
> > > > Forward with no attachment this time - I assume the information is =
still
> > > > enough in the paragraphs even without the flamegraphs.
> > >
> > > The flamegraphs are definitely useful beyond what is captured here.  =
Not sure
> > > how to get them accepted on the list though.
> >
> > Trying again with google drive:
> >
> > single uffd:
> > https://drive.google.com/file/d/1bYVYefIRRkW8oViRbYv_HyX5Zf81p3Jl/view
> >
> > 32 uffds:
> > https://drive.google.com/file/d/1T19yTEKKhbjU9G2FpANIvArSC61mqqtp/view
> >
> > >
> > > > > From what I got there, vmx_vcpu_load() gets more highlights than =
the
> > > > > spinlocks. I think that's the tlb flush broadcast.
> > >
> > > No, it's KVM dealing with the vCPU being migrated to a different pCPU=
.  The
> > > smp_call_function_single() that shows up is from loaded_vmcs_clear() =
and is
> > > triggered when KVM needs to VMCLEAR the VMCS on the _previous_ pCPU (=
yay for the
> > > VMCS caches not being coherent).
> > >
> > > Task migration can also trigger IBPB (if mitigations are enabled), an=
d also does
> > > an "all contexts" INVEPT, i.e. flushes all TLB entries for KVM's MMU.
> > >
> > > Can you trying 1:1 pinning of vCPUs to pCPUs?  That _should_ eliminat=
e the
> > > vmx_vcpu_load_vmcs() hotspot, and for large VMs is likely represenati=
ve of a real
> > > world configuration.
> >
> > Yes it does went away:
> >
> > https://drive.google.com/file/d/1ZFhWnWjoU33Lxy43jTYnKFuluo4zZArm/view
> >
> > With pinning vcpu threads only (again, over 40 hard cores/threads):
> >
> > ./demand_paging_test -b 512M -u MINOR -s shmem -v 32 -c 1,2,3,4,5,6,7,8=
,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
> >
> > It seems to me for some reason the scheduler ate more than I expected..
> > Maybe tomorrow I can try two more things:

I pulled in your patch adding the -c flag, and confirmed that it
doesn't seem to make a huge difference to the self test's
numbers/scalability. The percpu paging rate actually seems a bit
lower, going 117-103-77-55-18-9k for 1-32 vcpus

> >   - Do cpu isolations, and
> >   - pin reader threads too (or just leave the readers on housekeeping c=
ores)
>
> I gave it a shot by isolating 32 cores and split into two groups, 16 for
> uffd threads and 16 for vcpu threads.  I got similiar results and I don't
> see much changed.
>
> I think it's possible it's just reaching the limit of my host since it on=
ly
> got 40 cores anyway.  Throughput never hits over 350K faults/sec overall.
>
> I assume this might not be the case for Anish if he has a much larger hos=
t.
> So we can have similar test carried out and see how that goes.  I think t=
he
> idea is making sure vcpu load overhead during sched-in is ruled out, then
> see whether it can keep scaling with more cores.

Peter, I'm afraid that isolating cores and splitting them into groups
is new to me. Do you mind explaining exactly what you did here?

Also, I finally got some of my own perf traces for the self test: [1]
shows what happens with 32 vCPUs faulting on a single uffd with 32
reader threads, with the contention clearly being a huge issue, and
[2] shows the effect of demand paging through memory faults on that
configuration. Unfortunately the export-to-svg functionality on our
internal tool seems broken, so I could only grab pngs :(

[1] https://drive.google.com/file/d/1YWiZTjb2FPmqj0tkbk4cuH0Oq8l65nsU/view?=
usp=3Ddrivesdk
[2] https://drive.google.com/file/d/1P76_6SSAHpLxNgDAErSwRmXBLkuDeFoA/view?=
usp=3Ddrivesdk
