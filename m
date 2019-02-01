From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v8 09/26] ACPI / APEI: Generalise the estatus queue's
 notify code
Date: Fri, 1 Feb 2019 14:46:21 +0100
Message-ID: <20190201134602.GI31854@zn.tnic>
References: <20190129184902.102850-1-james.morse@arm.com>
 <20190129184902.102850-10-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0F294A32D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 08:46:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fokYKQYdtv-G for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 08:46:36 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C6454A320
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 08:46:36 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190129184902.102850-10-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 29, 2019 at 06:48:45PM +0000, James Morse wrote:
> +static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list)
> +{
> +	int err, ret = -ENOENT;
> +	struct ghes *ghes;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(ghes, rcu_list, list) {
> +		err = ghes_in_nmi_queue_one_entry(ghes);
> +		if (!err)
> +			ret = 0;

Do I understand this correctly that we want to do "ret = 0" for at least
one record which ghes_in_nmi_queue_one_entry() has succeeded queueing?

For those for which it has returned -ENOENT, estatus has been cleared,
nothing has been queued so we don't have to do anything for that
particular entry...

Btw, you don't really need the err variable:

		if (!ghes_in_nmi_queue_one_entry(ghes))
			ret = 0;

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
