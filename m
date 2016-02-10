From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 22/28] ARM: KVM: Switch to C-based stage2 init
Date: Wed, 10 Feb 2016 09:04:27 +0100
Message-ID: <20160210080427.GG5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-23-git-send-email-marc.zyngier@arm.com>
 <20160209184513.GX5171@cbox> <20160210074247.589db14b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E45749A9D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 02:58:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NG5f87lAUhoc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Feb 2016 02:57:59 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64C8349A9C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 02:57:59 -0500 (EST)
Received: by mail-wm0-f46.google.com with SMTP id 128so15518043wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Feb 2016 00:03:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160210074247.589db14b@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 10, 2016 at 07:42:47AM +0000, Marc Zyngier wrote:
> On Tue, 9 Feb 2016 19:45:13 +0100
> Christoffer Dall <christoffer.dall@linaro.org> wrote:
> 
> > Mising (sarcastic) commit message?
> 
> Ah! I'll try to think of something along the lines of:
> 
> "Let's now retire the code that bravely served us for three
> years, and enjoy a brand new set of bugs. At least, we can blame the
> compiler this time."
> 
You are the master of those ;)

-Christoffer
