From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 11/12] KVM: arm64: enable KVM_CAP_SET_GUEST_DEBUG
Date: Fri, 8 May 2015 19:21:07 +0200
Message-ID: <20150508172107.GL24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430989647-22501-4-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430989647-22501-4-git-send-email-alex.bennee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 07, 2015 at 10:07:14AM +0100, Alex Benn=E9e wrote:
> Finally advertise the KVM capability for SET_GUEST_DEBUG. Once arm
> support is added this check can be moved to the common
> kvm_vm_ioctl_check_extension() code.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
