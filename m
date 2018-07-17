From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: timer: add TVAL accessors
Date: Tue, 17 Jul 2018 12:52:42 +0200
Message-ID: <20180717105242.yobbkwvgq3kpq33g@kamzik.brq.redhat.com>
References: <20180716151438.9877-1-andre.przywara@arm.com>
 <20180716151438.9877-2-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00AF04A166
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jul 2018 06:39:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hQ5M7uuaidZ6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jul 2018 06:39:45 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 393F34A159
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jul 2018 06:39:45 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180716151438.9877-2-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 16, 2018 at 04:14:37PM +0100, Andre Przywara wrote:
> The ARM arch timer features the CVAL register, which holds an absolute
> value that is compared against the counter value.
> But there is also the TVAL register, which is defined as (CVAL - counter),
> and can be used to program or read relative timeouts.
> 
> Add accessors for the TVAL register, to be able to read and write them
> easily later.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/timer.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
