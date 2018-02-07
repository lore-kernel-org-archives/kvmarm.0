From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC v2 REPOST] arm64: KVM: KVM API extensions for SVE
Date: Wed, 7 Feb 2018 17:24:46 +0000
Message-ID: <20180207172446.GU5862@e103592.cambridge.arm.com>
References: <20180126172849.GX5862@e103592.cambridge.arm.com>
 <20180205161308.GW21802@cbox>
 <20180206114313.GQ5862@e103592.cambridge.arm.com>
 <20180206131757.GA23160@cbox>
 <20180207113327.GN5862@e103592.cambridge.arm.com>
 <20180207145831.GC29286@cbox>
 <20180207153402.GR5862@e103592.cambridge.arm.com>
 <20180207161750.GE29286@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180207161750.GE29286@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, libvir-list@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 07, 2018 at 05:17:50PM +0100, Christoffer Dall wrote:
> On Wed, Feb 07, 2018 at 03:34:03PM +0000, Dave Martin wrote:
> > On Wed, Feb 07, 2018 at 03:58:31PM +0100, Christoffer Dall wrote:
> > > On Wed, Feb 07, 2018 at 11:33:28AM +0000, Dave Martin wrote:

[...]

> > > > Alternatively, userspace would be require to do a KVM_ARM_SVE_GET_VLS,
> > > > and check the resulting set:
> > > > 
> > > > 	/* ... */
> > > > 	
> > > > 	__u64 newvqs[SVE_VQ_MAX / 64];
> > > > 	ioctl(vcpu_fd, KVM_ARM_SVE_GET_VLS, newvqs);
> > > > 
> > > > 	if (memcmp(vqs, newvqs, sizeof vqs))
> > > > 		goto mismatch;
> > > > 
> > > > vcpu restore would need to treat any mismatch as an error:
> > > > the exact requested set but be configurable, or the VM may go wrong.
> > > 
> > > I'm not sure I can parse this sentence or extract the meaning?
> > 
> > That was lazy language on my part.  I'll try to explain it better:
> > 
> > When the saved state of a migrating vcpu is being loaded into a
> > newly-created vcpu on the target node, userspace needs a way to
> > ensure that the set of VLs that vcpu will see when it runs is
> > _exactly_ the same set it could see before migration.
> 
> Yes, and that should work fine with the -ERANGE proposal, right?

Yes, that's the idea.

> > I called this out separately because it's different from the
> > case of creating a brand-new VM: in the latter case, we can't the
> > kernel to provide the best set of VLs possible, but it is not an
> > error not to get every VL we asked for.
> 
> This was another hard one:)
> 
> I think what you're saying is that it's technically not an error when
> setting the VLs on a new VM, but it would be in the case of migration,
> and therefore we need to tell userspace in both cases what happened, and
> it can decide.
> 
> > > > Any opinion on which approach is best?
> > > 
> > > I think I prefer letting KVM_ARM_SVE_SET_VLS change the supplied vqs,
> > > since having it be two separate ioctls always potentially leaves room
> > > for some other thread having modified the set in the meantime (or making
> > > a programmer doubt if this can be the case) where a single ioctl() will
> > > look atomic.
> > > 
> > > The user can always call KVM_ARM_SVE_GET_VLS afterwards and should get
> > > the same result.
> > 
> > OK, I'll go with changing the supplied vqs for KVM_ARM_SVE_SET_VLS,
> > but I'll retain the -ERANGE semantics (even if technically redundant)
> > since that's harder to forget to check.
> 
> Agree, that should definitely be part of it.

Agreed.

Cheers
---Dave
