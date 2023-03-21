Received: from out-15.mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026DBD2ED
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 17:32:14 +0000 (UTC)
Date: Tue, 21 Mar 2023 18:32:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679419931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7w4ZEi3YbIfHRVCRyPDA4Njekej7K6ZPISjlI0RqQ4Y=;
	b=w3eErXp5VgR9/2P5TjtGC6tRAoy/ghNE4BmXnU+jlcTl1dzwwvYsZpy30kjDvStULutR+l
	cGa5DZcUlGWblNsmg3PymEM0+HdRSouW9VdLHZf0aSE64ycD3l1ypbjXDCp05jhhbX4F2H
	lNUC2pbwGin2jk9DKR22bFTYYaspb4g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, pbonzini@redhat.com,
	alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [PATCH v4 04/30] lib: Apply Lindent to acpi.{c,h}
Message-ID: <20230321173210.kojqm6owufly7upk@orel>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-5-nikos.nikoleris@arm.com>
 <5a8887b2-a276-b087-964e-fa3f98826185@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a8887b2-a276-b087-964e-fa3f98826185@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 09, 2023 at 03:11:56PM +0800, Shaoqin Huang wrote:
...
> > +#define ACPI_TABLE_HEADER_DEF		/* ACPI common table header */			\
> > +	u32 signature;			/* ACPI signature (4 ASCII characters) */	\
> > +	u32 length;			/* Length of table, in bytes, including header */ \
> > +	u8  revision;			/* ACPI Specification minor version # */	\
> > +	u8  checksum;			/* To make sum of entire table == 0 */		\
> > +	u8  oem_id [6];			/* OEM identification */			\
>                   ^
> > +	u8  oem_table_id [8];		/* OEM table identification */			\
>                         ^
> > +	u32 oem_revision;		/* OEM revision number */			\
> > +	u8  asl_compiler_id [4];	/* ASL compiler vendor ID */			\
>                            ^
> nit: These space should also be deleted.
>

Yes, but the fixup belongs in the next patch that does manual style
changes.

Thanks,
drew
