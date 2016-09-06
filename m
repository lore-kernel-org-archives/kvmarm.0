From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v2 1/7] arm64: KVM: Move GIC accessors to arch_gicv3.h
Date: Tue, 6 Sep 2016 13:33:30 +0100
Message-ID: <57CEB79A.4070902@arm.com>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-2-git-send-email-vladimir.murzin@arm.com>
 <20160905112859.GG26366@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A511549B56
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:25:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sYyWRLs6OCKq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 08:25:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA72649B4A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:25:08 -0400 (EDT)
In-Reply-To: <20160905112859.GG26366@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/09/16 12:28, Christoffer Dall wrote:
> On Tue, Aug 16, 2016 at 11:46:52AM +0100, Vladimir Murzin wrote:
>> Since we are going to share vgic-v3 save/restore code with ARM
>> keep arch specific accessors separately.
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> 
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> 

Thanks!

Vladimir
