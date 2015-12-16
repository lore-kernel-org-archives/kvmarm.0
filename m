From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/3] arm64: KVM: Add support for 16-bit VMID
Date: Wed, 16 Dec 2015 21:30:14 +0100
Message-ID: <20151216203014.GB24889@cbox>
References: <1447673298-25503-1-git-send-email-vladimir.murzin@arm.com>
 <1447673298-25503-4-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B16D341267
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 15:27:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CPoJeZkGNHqF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2015 15:27:51 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7A8A411F6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 15:27:51 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id p187so17895960wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2015 12:30:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1447673298-25503-4-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 16, 2015 at 11:28:18AM +0000, Vladimir Murzin wrote:
> The ARMv8.1 architecture extension allows to choose between 8-bit and
> 16-bit of VMID, so use this capability for KVM.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
