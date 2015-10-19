From: Michal Marek <mmarek@suse.com>
Subject: Re: [PATCH 2/9] KVM: arm: Do not indent the arguments of
 DECLARE_BITMAP
Date: Mon, 19 Oct 2015 13:55:24 +0200
Message-ID: <5624DA2C.1000100@suse.com>
References: <1444940195-28272-1-git-send-email-mmarek@suse.com>
 <1444940195-28272-3-git-send-email-mmarek@suse.com>
 <20151018203458.GE7531@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <20151018203458.GE7531@cbox>
Sender: linux-kbuild-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 2015-10-18 22:34, Christoffer Dall wrote:
> On Thu, Oct 15, 2015 at 10:16:28PM +0200, Michal Marek wrote:
>> Besides being a coding style issue, it confuses make tags:
>>
>> ctags: Warning: include/kvm/arm_vgic.h:307: null expansion of name pattern "\1"
>> ctags: Warning: include/kvm/arm_vgic.h:308: null expansion of name pattern "\1"
>> ctags: Warning: include/kvm/arm_vgic.h:309: null expansion of name pattern "\1"
>> ctags: Warning: include/kvm/arm_vgic.h:317: null expansion of name pattern "\1"
>>
>> Cc: kvmarm@lists.cs.columbia.edu
>> Signed-off-by: Michal Marek <mmarek@suse.com>
>> ---
> 
> Is not being able to deal with a whitespace not a make tags problem?

Yes, but the regular expressions are hardly readable already :-(.


> As for coding style, do we really entertain these kinds of changes just
> to adhere to a coding style?  It feels unnecessary taints the log etc.

I wouldn't have submitted this just for the sake of coding style, it was
the ctags warning prompted me to do so.


> However, I'm curious what the general concesus and previous practice for
> this sort of thing is?

This KVM header was the only instance where whitespace confused the
patterns, so I'd say it's established practice not to do this. The other
ctags warnings were about multi-line macro invocations, where the
line-oriented regular expression rules cannot work.

Michal
