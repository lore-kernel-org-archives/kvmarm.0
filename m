From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 05/12] KVM: arm: introduce
 kvm_arm_init/setup/clear_debug
Date: Thu, 4 Jun 2015 13:07:40 +0200
Message-ID: <20150604110740.GH7657@cbox>
References: <1432891828-4816-1-git-send-email-alex.bennee@linaro.org>
 <1432891828-4816-6-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432891828-4816-6-git-send-email-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Andre Przywara <andre.przywara@arm.com>, Richard Weinberger <richard@nod.at>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 29, 2015 at 10:30:21AM +0100, Alex Benn=E9e wrote:
> This is a precursor for later patches which will need to do more to
> setup debug state before entering the hyp.S switch code. The existing
> functionality for setting mdcr_el2 has been moved out of hyp.S and no=
w
> uses the value kept in vcpu->arch.mdcr_el2.
>=20
> As the assembler used to previously mask and preserve MDCR_EL2.HPMN I=
've
> had to add a mechanism to save the value of mdcr_el2 as a per-cpu
> variable during the initialisation code. The kernel never sets this
> number so we are assuming the bootcode has set up the correct value
> here.
>=20
> This also moves the conditional setting of the TDA bit from the hyp c=
ode
> into the C code which is currently used for the lazy debug register
> context switch code.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
