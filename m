From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V14 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Thu, 13 Apr 2017 22:47:45 +0200
Message-ID: <20170413204744.iizyyi32v4hjt3fc@pd.tnic>
References: <1490729440-32591-1-git-send-email-tbaicar@codeaurora.org>
 <1490729440-32591-3-git-send-email-tbaicar@codeaurora.org>
 <20170412133447.n2yft7v266v6k6gh@pd.tnic>
 <8a31ef45-68f6-d444-f174-4a485cccd696@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DEC840BAC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Apr 2017 16:45:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CZxBLX3-46uM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Apr 2017 16:45:23 -0400 (EDT)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6F6B40187
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Apr 2017 16:45:23 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <8a31ef45-68f6-d444-f174-4a485cccd696@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 13, 2017 at 02:30:21PM -0600, Baicar, Tyler wrote:
> I do not agree with this. The struct being passed to this function is
> already named acpi_hest_generic_data in the existing code and all over this
> code is named gdata not just d.

And I'm saying they're too long - the preexisting ones and the ones
you're adding - and impair readability. This whole driver is one
unreadable ugly pile and if I were the maintainer I would never allowed
it in its current form.

But I don't think it really has a maintainer - poor Rafael has to deal
with it because it is under drivers/acpi/ and that whole RAS firmware
crap got thrown over the wall at some point and now we're stuck with it.

So this is just my opinion since he asked me to take a look.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
