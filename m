From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v2 2/5] arm64: Work around Falkor erratum 1003
Date: Fri, 6 Jan 2017 10:44:31 -0500
Message-ID: <54ceb523-47ea-f137-293f-0da0166bb14b@codeaurora.org>
References: <20161229224335.13531-1-cov@codeaurora.org>
 <20161229224335.13531-2-cov@codeaurora.org>
 <ac275374-2aa6-43ec-25c9-6a3fec4ceedc@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEA6240423
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 10:42:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nNbulQwVMSdi for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jan 2017 10:42:57 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 291A4403FB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 10:42:56 -0500 (EST)
In-Reply-To: <ac275374-2aa6-43ec-25c9-6a3fec4ceedc@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Timur Tabi <timur@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/29/2016 06:08 PM, Timur Tabi wrote:
> On 12/29/2016 04:43 PM, Christopher Covington wrote:
>> +config QCOM_FALKOR_E1003_RESERVED_ASID
>> +    int
>> +    default 1
>> +    depends on QCOM_FALKOR_ERRATUM_1003
> 
> Also, since this can't be changed via the menu, why bother putting it in?

I put it in in response to review comments asking for the magic number to
be clarified by a #define or variable. I could not find a suitably shared
header between the files in question, so I used the Kconfig machinery to
generate the #define.

Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
