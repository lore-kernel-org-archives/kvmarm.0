From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 11/24] KVM: arm64: vgic-its: Interpret MAPD Size field
 and check related errors
Date: Fri, 5 May 2017 10:44:59 +0100
Message-ID: <ffba5954-20c4-e482-5be0-df90646429b5@arm.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-12-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6232240BC5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 May 2017 05:41:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wB6549k7qnRf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 May 2017 05:41:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5492840190
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 May 2017 05:41:56 -0400 (EDT)
In-Reply-To: <1493898284-29504-12-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 04/05/17 12:44, Eric Auger wrote:
> Up to now the MAPD's ITT size field has been ignored. It encodes
> the number of eventid bit minus 1. It should be used to check
> the eventid when a MAPTI command is issued on a device. Let's
> store the number of eventid bits in the its_device and do the
> check on MAPTI. Also make sure the ITT size field does
> not exceed the GITS_TYPER IDBITS field.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Christoffer Dall <cdall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
