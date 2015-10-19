From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/9] KVM: arm: Do not indent the arguments of
 DECLARE_BITMAP
Date: Mon, 19 Oct 2015 14:05:56 +0200
Message-ID: <20151019120556.GC24104@cbox>
References: <1444940195-28272-1-git-send-email-mmarek@suse.com>
 <1444940195-28272-3-git-send-email-mmarek@suse.com>
 <20151018203458.GE7531@cbox>
 <5624DA2C.1000100@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5624DA2C.1000100@suse.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Michal Marek <mmarek@suse.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 19, 2015 at 01:55:24PM +0200, Michal Marek wrote:
> On 2015-10-18 22:34, Christoffer Dall wrote:
> > On Thu, Oct 15, 2015 at 10:16:28PM +0200, Michal Marek wrote:
> >> Besides being a coding style issue, it confuses make tags:
> >>
> >> ctags: Warning: include/kvm/arm_vgic.h:307: null expansion of name pattern "\1"
> >> ctags: Warning: include/kvm/arm_vgic.h:308: null expansion of name pattern "\1"
> >> ctags: Warning: include/kvm/arm_vgic.h:309: null expansion of name pattern "\1"
> >> ctags: Warning: include/kvm/arm_vgic.h:317: null expansion of name pattern "\1"
> >>
> >> Cc: kvmarm@lists.cs.columbia.edu
> >> Signed-off-by: Michal Marek <mmarek@suse.com>
> >> ---
> > 
> > Is not being able to deal with a whitespace not a make tags problem?
> 
> Yes, but the regular expressions are hardly readable already :-(.
> 
> 
> > As for coding style, do we really entertain these kinds of changes just
> > to adhere to a coding style?  It feels unnecessary taints the log etc.
> 
> I wouldn't have submitted this just for the sake of coding style, it was
> the ctags warning prompted me to do so.
> 
> 
> > However, I'm curious what the general concesus and previous practice for
> > this sort of thing is?
> 
> This KVM header was the only instance where whitespace confused the
> patterns, so I'd say it's established practice not to do this. The other
> ctags warnings were about multi-line macro invocations, where the
> line-oriented regular expression rules cannot work.
> 

ok, I've taken the patch.

-Christoffer
