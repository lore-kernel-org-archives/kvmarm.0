From: Christoffer Dall <cdall@linaro.org>
Subject: Re: Android on virt device
Date: Thu, 2 Mar 2017 14:04:42 +0100
Message-ID: <20170302130442.GL1409@cbox>
References: <6e04464a-9570-7d62-4bf4-9bbc1fb46e6b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7A9840B8B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Mar 2017 08:03:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DuG-rKnTIws4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Mar 2017 08:03:48 -0500 (EST)
Received: from mail-wr0-f175.google.com (mail-wr0-f175.google.com
 [209.85.128.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74A7E40A74
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Mar 2017 08:03:47 -0500 (EST)
Received: by mail-wr0-f175.google.com with SMTP id u108so51583236wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Mar 2017 05:05:00 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <6e04464a-9570-7d62-4bf4-9bbc1fb46e6b@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Roman Livshits <romanliv@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Feb 26, 2017 at 12:12:35PM +0200, Roman Livshits wrote:
> Hi
> 
> I am trying to run Android on qemu virt machine.
> I want to use virt as this was used by the op-tee for implementing
> TEE for ARM TrustZone, see
> https://github.com/OP-TEE/build#op-tee-buildgit, so hope that
> running Android on virt would be easier comparing to putting op-tee
> to ranchu, used by Android emulator
> (http://www.linaro.org/blog/core-dump/running-64bit-android-l-qemu/).
> 
> Is there any advice how to do this?
> 

You'd need an Android guest kernel that runs on the virt board and you
may also need some userspace changes, because I believe the initial user
deamons in Android loads libraries and hardware management layers based
on the machine name (e..g Ranchu).

The biggest challenge, however, is probably going to get the number of
devices needed to get Android booting properly so that you can interact
with it working on the virt board.  For example, I'm not sure how you
plan on dealing with the framebuffer/graphics.

Personally, for a quick solution, I would probably go the other route
and first try to make Android run under KVM using the Ranchu device
without any secure component.  Then I would look at bringing together
the work in whichever of the two platforms you prefer.

The Ranchu platform should be relatively similar to the virt platform,
so I wouldn't expect too much work in getting OP-TEE compiled and
running with Ranchu.

Hope this helps,
-Christoffer
