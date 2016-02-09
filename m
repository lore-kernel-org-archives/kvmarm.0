From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 24/28] ARM: KVM: Turn CP15 defines to an enum
Date: Tue, 9 Feb 2016 19:45:22 +0100
Message-ID: <20160209184522.GZ5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-25-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4C4649A18
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 13:38:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xIU-1g+kxUYN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2016 13:38:57 -0500 (EST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7044499E8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 13:38:56 -0500 (EST)
Received: by mail-wm0-f48.google.com with SMTP id p63so35585578wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Feb 2016 10:44:45 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454583645-10144-25-git-send-email-marc.zyngier@arm.com>
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

On Thu, Feb 04, 2016 at 11:00:41AM +0000, Marc Zyngier wrote:
> Just like on arm64, having the CP15 registers expressed as a set
> of #defines has been very conflict-prone. Let's turn it into an
> enum, which should make it more manageable.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
