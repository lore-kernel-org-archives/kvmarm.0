From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 09/11] KVM: arm/arm64: merge GICv3 RD_base and SGI_base
 register frames
Date: Fri, 27 Mar 2015 00:14:07 +0000
Message-ID: <5514A0CF.80907@arm.com>
References: <1427380778-942-1-git-send-email-andre.przywara@arm.com>	<1427380778-942-10-git-send-email-andre.przywara@arm.com>
 <20150326215308.74b994ff@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFEAD49E0C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 20:10:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QxKURoh4SABu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 20:10:09 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A765E49E00
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 20:10:08 -0400 (EDT)
In-Reply-To: <20150326215308.74b994ff@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/26/2015 09:53 PM, Marc Zyngier wrote:
> On Thu, 26 Mar 2015 14:39:36 +0000
> Andre Przywara <andre.przywara@arm.com> wrote:
> 
>> Currently we handle the redistributor registers in two separate MMIO
>> regions, one for the overall behaviour and SPIs and one for the
>> SGIs/PPIs. That latter forces the creation of _two_ KVM I/O bus
>> devices for each redistributor.
>> Since the spec mandates those two pages to be contigious, we could as
>> well merge them and save the churn with the second KVM I/O bus device.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> I wonder why we didn't have it that way the first place...

Me too ;-)

> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks!
Andre.
