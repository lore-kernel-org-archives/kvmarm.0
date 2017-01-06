From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH v2 2/5] arm64: Work around Falkor erratum 1003
Date: Fri, 6 Jan 2017 09:49:13 -0600
Message-ID: <e1f88cbb-f3b8-7de4-4aed-004c7610da0a@codeaurora.org>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-2-cov@codeaurora.org>
 <ac275374-2aa6-43ec-25c9-6a3fec4ceedc@codeaurora.org>
 <54ceb523-47ea-f137-293f-0da0166bb14b@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 823E140430
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 10:47:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QnNHSz5+E2dh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jan 2017 10:47:38 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C435D40423
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 10:47:38 -0500 (EST)
In-Reply-To: <54ceb523-47ea-f137-293f-0da0166bb14b@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Christopher Covington wrote:
>> > Also, since this can't be changed via the menu, why bother putting it in?
> I put it in in response to review comments asking for the magic number to
> be clarified by a #define or variable. I could not find a suitably shared
> header between the files in question, so I used the Kconfig machinery to
> generate the #define.

I don't think that's the right approach.  Kconfigs are not an 
alternative to header files.  Is the ASID configurable?  If you just put 
some text after the "int" then it because a menu option that the user 
can select and change.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
