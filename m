From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 06/12] KVM: arm64: guest debug, add SW break point
 support
Date: Wed, 20 May 2015 10:17:35 +0100
Message-ID: <20150520091735.GB8986@arm.com>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
 <1431700035-23479-7-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431700035-23479-7-git-send-email-alex.bennee@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "agraf@suse.de" <agraf@suse.de>, "drjones@redhat.com" <drjones@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "r65777@freescale.com" <r65777@freescale.com>, "bp@suse.de" <bp@suse.de>, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <Catalin.Marinas@arm.com>, "open list:DOCUMENTATION" <linux-do>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On Fri, May 15, 2015 at 03:27:09PM +0100, Alex Benn=E9e wrote:
> This adds support for SW breakpoints inserted by userspace.
>=20
> We do this by trapping all guest software debug exceptions to the
> hypervisor (MDCR_EL2.TDE). The exit handler sets an exit reason of
> KVM_EXIT_DEBUG with the kvm_debug_exit_arch structure holding the
> exception syndrome information.
>=20
> It will be up to userspace to extract the PC (via GET_ONE_REG) and
> determine if the debug event was for a breakpoint it inserted. If not
> userspace will need to re-inject the correct exception restart the
> hypervisor to deliver the debug exception to the guest.
>=20
> Any other guest software debug exception (e.g. single step or HW
> assisted breakpoints) will cause an error and the VM to be killed. Th=
is
> is addressed by later patches which add support for the other debug
> types.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>=20
> ---
> v2
>   - update to use new exit struct
>   - tweak for C setup
>   - do our setup in debug_setup/clear code
>   - fixed up comments
> v3:
>   - fix spacing in KVM_GUESTDBG_VALID_MASK
>   - fix and clarify wording on kvm_handle_guest_debug
>   - handle error case in kvm_handle_guest_debug
>   - re-word the commit message
> v4
>   - rm else leg
>   - add r-b-tag
>=20
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtua=
l/kvm/api.txt
> index ba635c7..33c8143 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt

Not sure why, but your patches seem to drop the diffstat which makes it
slightly more onerous for reviewers trying to figure out which bits tou=
ch
their trees. Are you removing it manually?

Will
