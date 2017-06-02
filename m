From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH] arm64/kvm: fix misleading kconfig text for 16K pages
Date: Fri, 2 Jun 2017 12:08:16 +0100
Message-ID: <56353731-e2ee-3784-8f22-6c300e6fa26c@arm.com>
References: <1496401340-24802-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18A1540992
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 07:04:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jZNQ6RrtCjzO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jun 2017 07:04:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E868E40625
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 07:04:20 -0400 (EDT)
In-Reply-To: <1496401340-24802-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 02/06/17 12:02, Mark Rutland wrote:
> We've supported KVM with 16K pages since commit:
>
>   02e0b7600f835007 ("arm64: kvm: Add support for 16K pages")
>
> ... yet the kconfig text says this combination is not supported.
>
> Let's fix that by deleting the misleading text.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu

Thanks for fixing that up

Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
