Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E5B208A2;
	Thu, 14 Sep 2023 12:04:59 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Rmbb90TM0z6K6W4;
	Thu, 14 Sep 2023 20:04:21 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Thu, 14 Sep
 2023 13:04:56 +0100
Date: Thu, 14 Sep 2023 13:04:55 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: James Morse <james.morse@arm.com>
CC: <linux-pm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<x86@kernel.org>, Salil Mehta <salil.mehta@huawei.com>, Russell King
	<linux@armlinux.org.uk>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	<jianyong.wu@arm.com>, <justin.he@arm.com>
Subject: Re: [RFC PATCH v2 12/35] ACPI: Use the acpi_device_is_present()
 helper in more places
Message-ID: <20230914130455.00004434@Huawei.com>
In-Reply-To: <20230913163823.7880-13-james.morse@arm.com>
References: <20230913163823.7880-1-james.morse@arm.com>
	<20230913163823.7880-13-james.morse@arm.com>
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
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 13 Sep 2023 16:38:00 +0000
James Morse <james.morse@arm.com> wrote:

> acpi_device_is_present() checks the present or functional bits
> from the cached copy of _STA.
> 
> A few places open-code this check. Use the helper instead to
> improve readability.
> 
> Signed-off-by: James Morse <james.morse@arm.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Pull this one out and send it upstream in advance of the rest.

Jonathan


> ---
>  drivers/acpi/scan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 691d4b7686ee..ed01e19514ef 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -304,7 +304,7 @@ static int acpi_scan_device_check(struct acpi_device *adev)
>  	int error;
>  
>  	acpi_bus_get_status(adev);
> -	if (adev->status.present || adev->status.functional) {
> +	if (acpi_device_is_present(adev)) {
>  		/*
>  		 * This function is only called for device objects for which
>  		 * matching scan handlers exist.  The only situation in which
> @@ -338,7 +338,7 @@ static int acpi_scan_bus_check(struct acpi_device *adev, void *not_used)
>  	int error;
>  
>  	acpi_bus_get_status(adev);
> -	if (!(adev->status.present || adev->status.functional)) {
> +	if (!acpi_device_is_present(adev)) {
>  		acpi_scan_device_not_present(adev);
>  		return 0;
>  	}

