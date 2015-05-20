From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v4 06/12] KVM: arm64: guest debug, add SW break point support
Date: Wed, 20 May 2015 13:33:48 +0100
Message-ID: <87bnhfig2b.fsf@linaro.org>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org> <1431700035-23479-7-git-send-email-alex.bennee@linaro.org> <20150520091735.GB8986@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20150520091735.GB8986@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "agraf@suse.de" <agraf@suse.de>, "drjones@redhat.com" <drjones@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "r65777@freescale.com" <r65777@freescale.com>, "bp@suse.de" <bp@suse.de>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <Catalin.Marinas@arm.com>, open list:DOCUMENTAT
List-Id: kvmarm@lists.cs.columbia.edu


Will Deacon <will.deacon@arm.com> writes:

> Hi Alex,
>
> On Fri, May 15, 2015 at 03:27:09PM +0100, Alex Benn=C3=A9e wrote:
>> This adds support for SW breakpoints inserted by userspace.
>>=20
>> We do this by trapping all guest software debug exceptions to the
>> hypervisor (MDCR_EL2.TDE). The exit handler sets an exit reason of
>> KVM_EXIT_DEBUG with the kvm_debug_exit_arch structure holding the
>> exception syndrome information.
>>=20
>> It will be up to userspace to extract the PC (via GET_ONE_REG) and
>> determine if the debug event was for a breakpoint it inserted. If no=
t
>> userspace will need to re-inject the correct exception restart the
>> hypervisor to deliver the debug exception to the guest.
>>=20
>> Any other guest software debug exception (e.g. single step or HW
>> assisted breakpoints) will cause an error and the VM to be killed. T=
his
>> is addressed by later patches which add support for the other debug
>> types.
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>>=20
>> ---
>> v2
>>   - update to use new exit struct
>>   - tweak for C setup
>>   - do our setup in debug_setup/clear code
>>   - fixed up comments
>> v3:
>>   - fix spacing in KVM_GUESTDBG_VALID_MASK
>>   - fix and clarify wording on kvm_handle_guest_debug
>>   - handle error case in kvm_handle_guest_debug
>>   - re-word the commit message
>> v4
>>   - rm else leg
>>   - add r-b-tag
>>=20
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtu=
al/kvm/api.txt
>> index ba635c7..33c8143 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>
> Not sure why, but your patches seem to drop the diffstat which makes =
it
> slightly more onerous for reviewers trying to figure out which bits t=
ouch
> their trees. Are you removing it manually?

No - I'm running:

git pps -v 4 origin/master..HEAD -o guestdbg.patches

Where pps is an alias:

pps =3D format-patch --cover-letter --summary

Manually expanding the alias gives the same results. I'll have a dig to
see what's going on.

>
> Will

--=20
Alex Benn=C3=A9e
