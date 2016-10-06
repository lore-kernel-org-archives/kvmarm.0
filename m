From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: kvmarm on i.MX6Quad
Date: Thu, 6 Oct 2016 13:49:07 -0700
Message-ID: <CAFEAcA90_VYLGfSFKHx2d+QDWMP4omrS3NGYUX0Ctzg8sn_ZMA@mail.gmail.com>
References: <CAAHpSfgVQPTmMnV3oq9Z47s7XEc1wE_oh1cin_U=q78BeEux1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ED1A49B77
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2016 16:39:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4zXTR7yiHdB2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Oct 2016 16:39:40 -0400 (EDT)
Received: from mail-vk0-f46.google.com (mail-vk0-f46.google.com
 [209.85.213.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2477849B75
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2016 16:39:40 -0400 (EDT)
Received: by mail-vk0-f46.google.com with SMTP id z126so29326983vkd.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Oct 2016 13:49:28 -0700 (PDT)
In-Reply-To: <CAAHpSfgVQPTmMnV3oq9Z47s7XEc1wE_oh1cin_U=q78BeEux1g@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Madhuri Yechuri <cosmokramer@gmail.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 6 October 2016 at 12:15, Madhuri Yechuri <cosmokramer@gmail.com> wrote:
> Has anyone successfully run KVMARM on i.MX6Quad 1.2GHz 4 Core dev kit (32
> bit Cortex-A9)? i will be giving it a try next week, hence asking.

The Cortex-A9 CPU does not implement the virtualization
extensions, so you can't run KVM on it.

thanks
-- PMM
