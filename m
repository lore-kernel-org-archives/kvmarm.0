From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 01/28] ARM: KVM: Move the  HYP code to its own section
Date: Tue, 9 Feb 2016 19:39:53 +0100
Message-ID: <20160209183953.GF5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAA884998E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 13:33:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id arQU0OMRsaf5 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2016 13:33:28 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBBCD498E6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 13:33:27 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id c200so73293362wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Feb 2016 10:39:16 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454583645-10144-2-git-send-email-marc.zyngier@arm.com>
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

On Thu, Feb 04, 2016 at 11:00:18AM +0000, Marc Zyngier wrote:
> In order to be able to spread the HYP code into multiple compilation
> units, adopt a layout similar to that of arm64:
> - the HYP text is emited in its own section (.hyp.text)
> - two linker generated symbols are use to identify the boundaries
>   of that section
> 
> No functionnal change.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
