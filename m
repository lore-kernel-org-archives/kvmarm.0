From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Output Guest cntvoff value
Date: Mon, 4 Jan 2016 15:23:21 +0100
Message-ID: <20160104142321.GB28354@cbox>
References: <1451674709-31074-1-git-send-email-amittomer25@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5E1849852
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 09:19:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q8MFoBmKShON for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2016 09:19:21 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9C80496F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2016 09:19:20 -0500 (EST)
Received: by mail-wm0-f46.google.com with SMTP id f206so174864316wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Jan 2016 06:22:53 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1451674709-31074-1-git-send-email-amittomer25@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: amittomer25@gmail.com
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Jan 02, 2016 at 12:28:29AM +0530, amittomer25@gmail.com wrote:
> From: Amit Tomar <amittomer25@gmail.com>
> 
> This provides an easy access to guest's CVTVOFF value, somewhat
> similar to how x86 outputs TSC offset value.
> 
> Signed-off-by: Amit Singh Tomar <amittomer25@gmail.com>

Out of curiosity, what is the value of having this?

Thanks,
-Christoffer
