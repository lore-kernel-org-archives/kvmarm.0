From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 26/41] KVM: arm64: Introduce framework for accessing
 deferred sysregs
Date: Tue, 13 Feb 2018 14:27:50 +0000
Message-ID: <20180213142749.GO5862@e103592.cambridge.arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-27-christoffer.dall@linaro.org>
 <20180123160431.GA5862@e103592.cambridge.arm.com>
 <20180125195413.GT21802@cbox>
 <20180209161739.GE5862@e103592.cambridge.arm.com>
 <20180213085502.GF23189@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180213085502.GF23189@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 13, 2018 at 09:55:02AM +0100, Christoffer Dall wrote:
> On Fri, Feb 09, 2018 at 04:17:39PM +0000, Dave Martin wrote:
> > On Thu, Jan 25, 2018 at 08:54:13PM +0100, Christoffer Dall wrote:
> > > On Tue, Jan 23, 2018 at 04:04:40PM +0000, Dave Martin wrote:

[...]

> > > > The individual accessor functions also become unnecessary in this case,
> > > > because we wouldn't need to derive function pointers from them any
> > > > more.
> > > > 
> > > > I don't know how performance would compare in practice though.
> > > 
> > > I don't know either.  But I will say that the whole idea behind put/load
> > > is that you do this rarely, and going to userspace from KVM is
> > > notriously expensive, also on x86.
> > 
> > I guess that makes sense.  I'm still a bit hazy on the big picture
> > for KVM.
> > 
> > > > I'm also assuming that all calls to these accessors are const-foldable.
> > > > If not, relying on inlining would bloat the generated code a lot.
> > > 
> > > We have places where this is not the cae, access_vm_reg() for example.
> > > But if we really, really, wanted to, we could rewrite that to have a
> > > function for each register, but that's pretty horrid on its own.
> > 
> > That might not be too bad if there is only one giant inline expansion
> > and the rest are folded down.
> > 
> > 
> > I guess this is something to revisit _if_ we suspect a performance
> > bottleneck later on.
> > 
> > For now, I was lacking some understanding regarding how this code gets
> > run, so I was guessing about potential issues rather then proven
> > issues.
> > 
> 
> This was a very useful discussion.  I think I'll change this to a big
> switch statement in the header file using a static inline, because it
> makes the code more readable, and if we notice a huge code size
> explosion, we can take measures to make sure things are const-foldable.

Sure, that sounds reasonable.

C99 inline semantics allow a single out-of-line body to be linked in
somewhere for when the function isn't inlined, so we might be able to
mitigate the bloat that way if it's a problem... unless the compiler
flags sabotage it (I remember GCC traditionally does something a bit
different where there's a particular difference between "inline" and
"extern inline".)

> > As you might guess, I'm still at the "stupid questions" stage for
> > this series :)
>
> Not at all.

Hmmm, I must try to be more stupid when I look at the other
patches...

Cheers
---Dave
