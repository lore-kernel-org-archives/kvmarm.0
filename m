From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v7 10/27] KVM: arm64: Propagate vcpu into read_id_reg()
Date: Thu, 4 Apr 2019 23:15:24 +0200
Message-ID: <20190404211524.nozvhcyvsaauhnz4@kamzik.brq.redhat.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-11-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1553864452-15080-11-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 29, 2019 at 01:00:35PM +0000, Dave Martin wrote:
> Architecture features that are conditionally visible to the guest
> will require run-time checks in the ID register accessor functions.
> In particular, read_id_reg() will need to perform checks in order
> to generate the correct emulated value for certain ID register
> fields such as ID_AA64PFR0_EL1.SVE for example.
> =

> This patch propagates vcpu into read_id_reg() so that future
> patches can add run-time checks on the guest configuration here.
> =

> For now, there is no functional change.
> =

> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
