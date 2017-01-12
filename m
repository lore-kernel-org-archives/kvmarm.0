From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC 07/13] KVM: arm64: ITS: Change entry_size and indirect bit
 in BASER
Date: Thu, 12 Jan 2017 17:05:29 +0000
Message-ID: <dc26dc19-313b-375b-0d9b-f4ff411a914f@arm.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
 <1484236613-24633-8-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70BBE401D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:03:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SXB6UEUfWtPq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 12:03:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 682AD4019A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:03:47 -0500 (EST)
In-Reply-To: <1484236613-24633-8-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, Prasun.Kapoor@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

On 12/01/17 15:56, Eric Auger wrote:
> Change the device table entry_size to 16 bytes instead of 8.
> We also Store the device and collection device in the its
> struct.
> 
> The patch also clears the indirect bit for the device BASER.
> The indirect bit is set as read-only.

Err... Why? We *really* want to continue supporting indirect tables, as
this is a massive memory saver for the guest.

> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> TODO: investigate support of 2 level tables, ie. enabling
> Indirect = 1. Support of 2 level tables is implementation
> defined.

Clearly, that's a regression. What exactly is the issue that decided you
to disable it?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
