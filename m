From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: Android guest on KVM/ARM
Date: Mon, 27 Jun 2016 08:28:23 +0200
Message-ID: <20160627062823.GA26498@cbox>
References: <20160622100606.GA6749@faubox.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4095B412ED
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 02:22:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qhzzBjZNmcyJ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2016 02:22:31 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EC5D412DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2016 02:22:30 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id v199so86081438wmv.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Jun 2016 23:27:37 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160622100606.GA6749@faubox.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ralph Palutke <ralph.palutke@fau.de>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 22, 2016 at 12:06:06PM +0200, Ralph Palutke wrote:
> Hello everyone,
> 
> I try to virtualize an Android system via KVM/ARM. Currently I've
> installed Linaro Debian 16.03 RBP on a Lemaker Hikey board. Now, is
> there any Android build that would suite my needs? Since the usual way
> to install Android on a board is via fastboot, I'm not sure how to
> install it as a KVM/ARM guest. Because I run it on an ARM board, I would
> have assumed I could run an unmodified Android guest.
> Any suggestions how to proceed?
> 

If I were you I would build AOSP and use the system, data, etc. images
provided by the build output and use that to generate some virtio
images.

I think emulating fastboot is a pretty hard way to go around things, but
of course it depends on what you're overall trying to do: Just run
Android or have a fully emulated Android compatible system...

Perhaps this will also help you:
http://www.linaro.org/blog/core-dump/running-64bit-android-l-qemu/

-Christoffer
