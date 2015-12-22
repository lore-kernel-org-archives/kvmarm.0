From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: kvmarm tags kvm-arm-for-4.2, 4.3, and v4.4-rc6 does not boot on
 Mustang
Date: Tue, 22 Dec 2015 15:41:35 +0100
Message-ID: <20151222144135.GB5631@cbox>
References: <567918E6.8020001@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E686648912
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 09:38:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WAyiXY3ufFLv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Dec 2015 09:38:43 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FB80412ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 09:38:42 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id p187so110787319wmp.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 06:41:26 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <567918E6.8020001@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 22, 2015 at 06:33:26PM +0900, Itaru Kitayama wrote:
> Hi,
> I have been trying to test one of the recent tags in kvmarm git tree,
> kvm-arm-for-4.2, 4.3, and v4.4-rc6 on Mustang, but none of them seem
> to enter the linux boot process. Has anyone verified any of these work
> on Mustang? If so can I have a working .config to continue testing?
> 
Just use mainline tags instead of the kvm-arm-specific ones.

Any recent kernel, like v4.3 or v4.4-rc6 boots just fine on my Mustang
with defconfig.

-Christoffer
