Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDCA14830C;
	Fri,  2 Feb 2024 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706892278; cv=none; b=owj4mmbdfkXopBgzl+6PNGWQH3QTH9OeWvegYhON4l7Y7C17xEy/FzuEL6gqUeN7T2vvz7R1DVe5R5ZlP6eV53jGAeNntr+sJcb4HaP/0Oa49YCELJg83i1lgsOcWzz7OLhpxJsUZh6sU8tM9rLwyO7yRJo7TuC61ifpZCxtAaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706892278; c=relaxed/simple;
	bh=91dKtYL6nn7sT6XBkJUZhgPHoMOoFPhDfSgFduym7O0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IO1cLI5W9GY5lZNaCBEM0klxkNv1hbQABPlRv0EJoMgehHD5E/mpQJjAEO899MVwUt9ncYHNjNzzWhrDgBXFHlDtmZ/dUtPXuc7HEBYxXEPQ5qxyKXWMNJqc0OxFSKLxcc82sWjgn0qAf8TMsr1r+izM/Mo53CMPZ99PaN375fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TRM3Q6Gpcz67pnj;
	Sat,  3 Feb 2024 00:41:06 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id B846A1400D4;
	Sat,  3 Feb 2024 00:44:32 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 2 Feb
 2024 16:44:31 +0000
Date: Fri, 2 Feb 2024 16:44:31 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC: <linux-pm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<x86@kernel.org>, <acpica-devel@lists.linuxfoundation.org>,
	<linux-csky@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-ia64@vger.kernel.org>, <linux-parisc@vger.kernel.org>, Salil Mehta
	<salil.mehta@huawei.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	<jianyong.wu@arm.com>, <justin.he@arm.com>, James Morse
	<james.morse@arm.com>, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH RFC v4 10/15] irqchip/gic-v3: Don't return errors from
 gic_acpi_match_gicc()
Message-ID: <20240202164431.00006f09@Huawei.com>
In-Reply-To: <E1rVDn9-0027ZB-QN@rmk-PC.armlinux.org.uk>
References: <Zbp5xzmFhKDAgHws@shell.armlinux.org.uk>
	<E1rVDn9-0027ZB-QN@rmk-PC.armlinux.org.uk>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Wed, 31 Jan 2024 16:50:27 +0000
Russell King (Oracle) <rmk+kernel@armlinux.org.uk> wrote:

> From: James Morse <james.morse@arm.com>
> 
> gic_acpi_match_gicc() is only called via gic_acpi_count_gicr_regions().
> It should only count the number of enabled redistributors, but it
> also tries to sanity check the GICC entry, currently returning an
> error if the Enabled bit is set, but the gicr_base_address is zero.
> 
> Adding support for the online-capable bit to the sanity check will
> complicate it, for no benefit. The existing check implicitly depends on
> gic_acpi_count_gicr_regions() previous failing to find any GICR regions
> (as it is valid to have gicr_base_address of zero if the redistributors
> are described via a GICR entry).
> 
> Instead of complicating the check, remove it. Failures that happen at
> this point cause the irqchip not to register, meaning no irqs can be
> requested. The kernel grinds to a panic() pretty quickly.
> 
> Without the check, MADT tables that exhibit this problem are still
> caught by gic_populate_rdist(), which helpfully also prints what went
> wrong:
> | CPU4: mpidr 100 has no re-distributor!
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Does what it says on the tin.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
