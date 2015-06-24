From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 00/12] KVM Guest Debug support for arm64
Date: Wed, 24 Jun 2015 22:19:15 +0200
Message-ID: <20150624201915.GC22785@cbox>
References: <1434716630-18260-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434716630-18260-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 19, 2015 at 01:23:38PM +0100, Alex Benn=C3=A9e wrote:
> Here is V6 of the KVM Guest Debug support for arm64.
>=20
> The changes are even more minimal than the last round which is
> hopefully a good indication the series is ready for merging:
>=20
Unfortunately this series breaks the build on 32-bit ARM:


/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c: In=
 function =E2=80=98kvm_arch_vcpu_init=E2=80=99:
/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c:283=
:12: error: =E2=80=98struct kvm_vcpu_arch=E2=80=99 has no member named =
=E2=80=98debug_ptr=E2=80=99
  vcpu->arch.debug_ptr =3D &vcpu->arch.vcpu_debug_state;
            ^
/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c:283=
:36: error: =E2=80=98struct kvm_vcpu_arch=E2=80=99 has no member named =
=E2=80=98vcpu_debug_state=E2=80=99
  vcpu->arch.debug_ptr =3D &vcpu->arch.vcpu_debug_state;
                                    ^
/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c: In=
 function =E2=80=98kvm_arch_vcpu_ioctl_set_guest_debug=E2=80=99:
/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c:309=
:8: error: =E2=80=98KVM_GUESTDBG_USE_SW_BP=E2=80=99 undeclared (first u=
se in this function)
        KVM_GUESTDBG_USE_SW_BP | \
        ^
/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c:328=
:22: note: in expansion of macro =E2=80=98KVM_GUESTDBG_VALID_MASK=E2=80=
=99
  if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
                      ^
/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c:309=
:8: note: each undeclared identifier is reported only once for each fun=
ction it appears in
        KVM_GUESTDBG_USE_SW_BP | \
        ^
/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c:328=
:22: note: in expansion of macro =E2=80=98KVM_GUESTDBG_VALID_MASK=E2=80=
=99
  if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
                      ^
/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c:310=
:8: error: =E2=80=98KVM_GUESTDBG_USE_HW=E2=80=99 undeclared (first use =
in this function)
        KVM_GUESTDBG_USE_HW | \
        ^
/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c:328=
:22: note: in expansion of macro =E2=80=98KVM_GUESTDBG_VALID_MASK=E2=80=
=99
  if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
                      ^
/home/christoffer/src/kvmarm/arm64/linux-kvm-arm/arch/arm/kvm/arm.c:336=
:14: error: =E2=80=98struct kvm_vcpu_arch=E2=80=99 has no member named =
=E2=80=98external_debug_state=E2=80=99
    vcpu->arch.external_debug_state =3D dbg->arch;
              ^
make[2]: *** [arch/arm/kvm/arm.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/arm/kvm] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [sub-make] Error 2


-Christoffer
