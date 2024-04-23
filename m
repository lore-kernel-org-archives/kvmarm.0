Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B3F85649;
	Tue, 23 Apr 2024 12:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713873740; cv=none; b=YT7cpgr5dmcNxKZaOI64ORgVU0kwhTJSYL9FzTetbvq2w0FdqPisfafTCd7zVkj11Ap54ZRrA1xauRbYTy8WtdFcT0PKGKhm14CqOflOI3UxNtrEryaNhbxFDDmaJt1w14CEiNyebMwKR8T/ufWYkudhaWYcEogA93/i0CTqp38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713873740; c=relaxed/simple;
	bh=hfKlsY4ZX33lVwyiKtYcBze9pmY4qL8hQv67+y8Zpf4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=nBUY1tKLraFI7pxG52SoXw05XjL6oQhUfUFwsFoixWbtUgmUnezYZnd/HhLNxs6QHZPC1DaQxqOgDR9F9+rIWcZ76u6Qi8zV1ISvsWXUEJjVZJ3w8sYnclgQ78mkmBXsaFVizAVma4Ph2nUC7fO8+2P1N23O7HDCZIsXSvDZZag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4VP0zN61SJzNngf;
	Tue, 23 Apr 2024 19:59:44 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (unknown [7.185.36.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 38ED71403D4;
	Tue, 23 Apr 2024 20:02:15 +0800 (CST)
Received: from [10.174.178.247] (10.174.178.247) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 20:02:14 +0800
Subject: Re: [PATCH v7 07/16] ACPI: scan: switch to flags for
 acpi_scan_check_and_detach()
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Thomas Gleixner
	<tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
	<linux-pm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <x86@kernel.org>, Russell King
	<linux@armlinux.org.uk>, "Rafael J . Wysocki" <rafael@kernel.org>, Miguel
 Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>, Salil Mehta
	<salil.mehta@huawei.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, <linuxarm@huawei.com>,
	<justin.he@arm.com>, <jianyong.wu@arm.com>
References: <20240418135412.14730-1-Jonathan.Cameron@huawei.com>
 <20240418135412.14730-8-Jonathan.Cameron@huawei.com>
From: Hanjun Guo <guohanjun@huawei.com>
Message-ID: <c85a710b-c4b5-1b7d-c9dd-db6207776ef2@huawei.com>
Date: Tue, 23 Apr 2024 20:02:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240418135412.14730-8-Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500002.china.huawei.com (7.185.36.229)

On 2024/4/18 21:54, Jonathan Cameron wrote:
> Precursor patch adds the ability to pass a uintptr_t of flags into
> acpi_scan_check_and detach() so that additional flags can be
> added to indicate whether to defer portions of the eject flow.
> The new flag follows in the next patch.
> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> ---
> v7: No change
> v6: Based on internal feedback switch to less invasive change
>      to using flags rather than a struct.
> ---
>   drivers/acpi/scan.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index d1464324de95..1ec9677e6c2d 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -244,13 +244,16 @@ static int acpi_scan_try_to_offline(struct acpi_device *device)
>   	return 0;
>   }
>   
> -static int acpi_scan_check_and_detach(struct acpi_device *adev, void *check)
> +#define ACPI_SCAN_CHECK_FLAG_STATUS	BIT(0)
> +
> +static int acpi_scan_check_and_detach(struct acpi_device *adev, void *p)
>   {
>   	struct acpi_scan_handler *handler = adev->handler;
> +	uintptr_t flags = (uintptr_t)p;
>   
> -	acpi_dev_for_each_child_reverse(adev, acpi_scan_check_and_detach, check);
> +	acpi_dev_for_each_child_reverse(adev, acpi_scan_check_and_detach, p);
>   
> -	if (check) {
> +	if (flags & ACPI_SCAN_CHECK_FLAG_STATUS) {
>   		acpi_bus_get_status(adev);
>   		/*
>   		 * Skip devices that are still there and take the enabled
> @@ -288,7 +291,9 @@ static int acpi_scan_check_and_detach(struct acpi_device *adev, void *check)
>   
>   static void acpi_scan_check_subtree(struct acpi_device *adev)
>   {
> -	acpi_scan_check_and_detach(adev, (void *)true);
> +	uintptr_t flags = ACPI_SCAN_CHECK_FLAG_STATUS;
> +
> +	acpi_scan_check_and_detach(adev, (void *)flags);
>   }
>   
>   static int acpi_scan_hot_remove(struct acpi_device *device)
> @@ -2601,7 +2606,9 @@ EXPORT_SYMBOL(acpi_bus_scan);
>    */
>   void acpi_bus_trim(struct acpi_device *adev)
>   {
> -	acpi_scan_check_and_detach(adev, NULL);
> +	uintptr_t flags = 0;
> +
> +	acpi_scan_check_and_detach(adev, (void *)flags);
>   }
>   EXPORT_SYMBOL_GPL(acpi_bus_trim);

Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
