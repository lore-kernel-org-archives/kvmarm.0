From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 4/6] arm: KVM: Delete unused macros
Date: Sun, 10 Jan 2016 17:32:13 +0100
Message-ID: <20160110163213.GF30867@cbox>
References: <1451166900-3711-1-git-send-email-m.smarduch@samsung.com>
 <1451166900-3711-5-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52A8649A82
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jan 2016 11:27:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iMeP5sc1jBRm for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Jan 2016 11:27:40 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 290E249A83
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jan 2016 11:27:40 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id f206so236081131wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Jan 2016 08:31:35 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1451166900-3711-5-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Dec 26, 2015 at 01:54:58PM -0800, Mario Smarduch wrote:
> set_hcptr is no longer used so delete it.
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
