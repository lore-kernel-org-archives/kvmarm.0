Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBABECAAA1
	for <kvmarm@archiver.kernel.org>; Sat, 17 Sep 2022 22:14:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9C2A4B7FA;
	Sat, 17 Sep 2022 18:14:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jo0ly5q4w-0A; Sat, 17 Sep 2022 18:14:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DCF14B7E7;
	Sat, 17 Sep 2022 18:14:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA0E4B7E7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2022 18:14:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rsSz5CPIGGkr for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Sep 2022 18:14:39 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C8434B73D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2022 18:14:39 -0400 (EDT)
Date: Sat, 17 Sep 2022 22:14:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663452877;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=03UR8Rb75BZSYr0d5kVIJFfLvNByoIKB6HgMt0K7jCc=;
 b=O10cC5iQonWkynMbdH+AkPZkiDQy2lvCzbV3f2LOXxEcTQwoldqwx/YibwGwOy8uwbFg1R
 YSjUHm5f3CcXbjMdP7V6ZutF+BiBA+FozlYLDKwXqWrFqS/Bro6cEhAK6Ebf+0VxCy6ElS
 Po1XJ1VcDiLRTYY1X4uuQW4bgz427Yg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v6 01/13] KVM: selftests: Add a userfaultfd library
Message-ID: <YyZGx3qMvG71c1y/@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220906180930.230218-2-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, maz@kernel.org,
 bgardon@google.com, pbonzini@redhat.com, axelrasmussen@google.com,
 kvmarm@lists.cs.columbia.edu, dmatlack@google.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Ricardo,

On Tue, Sep 06, 2022 at 06:09:18PM +0000, Ricardo Koller wrote:
> Move the generic userfaultfd code out of demand_paging_test.c into a
> common library, userfaultfd_util. This library consists of a setup and a
> stop function. The setup function starts a thread for handling page
> faults using the handler callback function. This setup returns a
> uffd_desc object which is then used in the stop function (to wait and
> destroy the threads).
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---

[...]

> diff --git a/tools/testing/selftests/kvm/include/userfaultfd_util.h b/tools/testing/selftests/kvm/include/userfaultfd_util.h
> new file mode 100644
> index 000000000000..a1a386c083b0
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/userfaultfd_util.h
> @@ -0,0 +1,46 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * KVM userfaultfd util
> + * Adapted from demand_paging_test.c

nit: Don't reference demand_paging_test.c, as it won't make sense unless
the reader also looks at this diff.

> + *
> + * Copyright (C) 2018, Red Hat, Inc.
> + * Copyright (C) 2019-2022 Google LLC
> + */

[...]

> diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> new file mode 100644
> index 000000000000..4395032ccbe4
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
> @@ -0,0 +1,187 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * KVM userfaultfd util
> + * Adapted from demand_paging_test.c
> + *
> + * Copyright (C) 2018, Red Hat, Inc.
> + * Copyright (C) 2019, Google, Inc.
> + * Copyright (C) 2022, Google, Inc.

nit: use the same copyrights as the header file.

With that:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
