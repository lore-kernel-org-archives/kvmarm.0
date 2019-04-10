From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 27/27] KVM: arm64/sve: Document KVM API extensions for
 SVE
Date: Wed, 10 Apr 2019 13:34:06 +0100
Message-ID: <20190410123405.GG3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <1553864452-15080-28-git-send-email-Dave.Martin@arm.com>
 <20190404210921.7xz6o56wietd77li@kamzik.brq.redhat.com>
 <20190405093617.GO3567@e103592.cambridge.arm.com>
 <20190405103937.quhaxxwkjjdxab6z@kamzik.brq.redhat.com>
 <20190405130007.GB3567@e103592.cambridge.arm.com>
 <20190405153804.qnw774e5bsudd2kn@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190405153804.qnw774e5bsudd2kn@kamzik.brq.redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 05, 2019 at 05:38:04PM +0200, Andrew Jones wrote:
> On Fri, Apr 05, 2019 at 02:00:07PM +0100, Dave Martin wrote:
> > On Fri, Apr 05, 2019 at 12:39:37PM +0200, Andrew Jones wrote:
> > > On Fri, Apr 05, 2019 at 10:36:17AM +0100, Dave Martin wrote:
> > > > On Thu, Apr 04, 2019 at 11:09:21PM +0200, Andrew Jones wrote:

[...]

> > > > > I'm still not sure about EPERM vs. ENOEXEC.
> > > > 
> > > > There is no need to distinguish the two: this is just a generic "vcpu in
> > > > wrong state for this to work" error.  I can't think of another subsystem
> > > > that uses ENOEXEC for this meaning, but it's established in KVM.
> > > > 
> > > > If you can't see a reason why we would need these to be distinct
> > > > errors (?) then I'm happy for this to be ENOEXEC for all cases.
> > > > 
> > > 
> > > I do see some value in keeping them distinct. I think it's just the use
> > > of EPERM specifically that bothers me, but I don't have that strong of
> > > an opinion against its use either. So I'll just shut up :)
> > 
> > In an earlier incarnation I had EBADFD, which does kind of mean the
> > right thing.
> > 
> > If there's not a clear way forward, I may leave this all as-is for now
> > (but I'll remove the explicit documentation for KVM_{GET,SET}_ONE_REG
> > error codes to give us more flexibility about this in the future, as
> > discussed).
> > 
> > Any objection?
> 
> Nope. Let's do that. EBADFD doesn't sound good, because we're using the FD
> without trouble before and even after we attempt these ioctls. I think
> EBADFD would indicate that no future ioctl (or read,write) should be
> expected to work.

OK.  I may also keep some of the error code documentation, but water it
down a bit to make it clearer that the error codes are indicate and
arm64-specifc.

We can see how it looks when I have a series to post.

Cheers
---Dave
