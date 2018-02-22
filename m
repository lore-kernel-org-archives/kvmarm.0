From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 10/40] KVM: arm64: Slightly improve debug save/restore
 functions
Date: Thu, 22 Feb 2018 09:05:25 +0100
Message-ID: <20180222080525.jjqtggrpyjdsltic@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-11-christoffer.dall@linaro.org>
 <20180221173903.xlpwnlrnjlpatm5s@kamzik.brq.redhat.com>
 <37712e4f-7f47-2101-71f5-d024a7993f13@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <37712e4f-7f47-2101-71f5-d024a7993f13@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Tomasz Nowicki <tn@semihalf.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 21, 2018 at 05:52:41PM +0000, Marc Zyngier wrote:
> On 21/02/18 17:39, Andrew Jones wrote:
> > On Thu, Feb 15, 2018 at 10:03:02PM +0100, Christoffer Dall wrote:
> >> The debug save/restore functions can be improved by using the has_vhe()
> >> static key instead of the instruction alternative.  Using the static key
> >> uses the same paradigm as we're going to use elsewhere, it makes the
> >> code more readable, and it generates slightly better code (no
> >> stack setups and function calls unless necessary).
> >>
> >> We also use a static key on the restore path, because it will be
> >> marginally faster than loading a value from memory.
> >>
> >> Finally, we don't have to conditionally clear the debug dirty flag if
> >> it's set, we can just clear it.
> >>
> >> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> >> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> ---
> >>
> >> Notes:
> >>     Changes since v1:
> >>      - Change dot to comma in comment
> >>      - Rename __debug_restore_spe to __debug_restore_spe_nvhe
> >>
> >>  arch/arm64/kvm/hyp/debug-sr.c | 26 ++++++++++++--------------
> >>  1 file changed, 12 insertions(+), 14 deletions(-)
> >>
> > 
> > Maybe after this series is merged, if there are any hyp_alternate_select's
> > left, we can replace all the remaining ones with has_vhe() and then just
> > completely remove hyp_alternate_select.
> 
> Note that older compilers (such as GCC 4.8) will generate horrible code
> with static keys, as they do not support "asm goto". Not that I want to
> preserve the home brew hyp_alternate_select mechanism, but I just want
> to make it plain that some distros will definitely suffer from the
> transition.

Yeah, I've seen that. I even wrote some patches to try and deal with
it once, because RHEL currently has gcc 4.8, and static keys are now
used in kernel hot paths for kpti, and I knew this series was coming.
My patches didn't seem like something usptream would care about, so
I never posted them. Indeed, I see here[*] that at least x86 is saying
that at some point (soon?) asm-goto will be a hard requirement.

I just checked Christoffer's branch. The only hyp_alternate_select,
that couldn't be changed to a has_vhe is __check_arm_834220, but
that one can just be changed to
cpus_have_const_cap(ARM64_WORKAROUND_834220), since it's just acting
as a boolean anyway.

Thanks,
drew

[*] https://lkml.org/lkml/2018/2/20/51
