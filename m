From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PULL 00/29] KVM/ARM Changes for v4.7
Date: Tue, 17 May 2016 11:16:16 -0500
Message-ID: <573B43D0.6020602@codeaurora.org>
References: <e368c757-f5a8-d3be-8b67-8270c756bd2b@riken.jp>
 <CAMJs5B-dGpg++5__cu2WOp40M0xwQjrPFfGhVhiLvnc6AkGiug@mail.gmail.com>
 <7292cb91-39d9-b859-b219-722db5c5dca4@riken.jp>
 <CAMJs5B_Csdt=BPFc36WtjqVwOdn_4+O6MOKCshEHrmepiEgpxA@mail.gmail.com>
 <90cab3e7-7eb3-cb76-5312-af68ee5af7eb@arm.com>
 <424fb79c-bf73-ba4d-7a66-f7ce72dee897@riken.jp>
 <CAMJs5B85MbBqK8NaDtEvFB5zSwWMFY90t=w=JqAjxA0aHhc+6g@mail.gmail.com>
 <b333057e-3813-bb32-0186-bddfd7689e89@riken.jp>
 <0b0fb6cc-e208-d3e1-e6f1-9e99ce6a663c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D3984113E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2016 12:13:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qsqkv0Uc-ahJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 May 2016 12:13:04 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39C33410B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2016 12:13:03 -0400 (EDT)
In-Reply-To: <0b0fb6cc-e208-d3e1-e6f1-9e99ce6a663c@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, Itaru Kitayama <itaru.kitayama@riken.jp>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Itaru,

Look at this commit that might be causing the problem.

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/firmware/efi/arm-runtime.c?id=14c43be60166981f0b1f034ad9c59252c6f99e0d

Review your EFI system table and runtime service region attributes.

On 05/17/2016 03:00 AM, Julien Grall wrote:
> Hello,
>
> On 17/05/2016 00:28, Itaru Kitayama wrote:
>> The new v4.6 upstream kernel gets to the prompt on Mustang (Rev A3).
>
> I would recommend you to bissect Linux and finger one or multiple commits which break booting on your board.
>
> Regards,
>

-- 
Shanker Donthineni
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
