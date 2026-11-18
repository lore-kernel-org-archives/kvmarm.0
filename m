Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015303;
	b=cSAt91Usw2CYLRAB26enKXt5xOzQfipgaJrbKeiG66mqaneeblo+YMJ39DnkHTj7fqlF
	 frZO/He4KhASDEu4i8nn19CmLkmRuc/R8iRPKMXVdPOt2awNyFbx42HNfeAoN7Xdxlp85
	 mvkd3NanWbrg8vIUXtt3mWA/zzUDlilPGU+raNtMreOaawi3dLLWHX5sP5iPUO0ngFW8c
	 DAxxUOU+bfKCJ0AR6TiNrv6YfCjO+fC10CdEp8USfkvhV5AB9JpBDftsOdxAidfpSu2Yu
	 A1clNNmpHPuoP2+TIartt968KRYfZoKkCGtMCuKQi2JuWbCKq2vp+Vb5V63AK5j+tpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015303;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=aQ6kcBssDb8tDV/EoFUnh55XQz8448Jqr7uQGVfML8Y=;
	b=FSqrCY2Cwd7hH1kyRl9u56fcEoLWzg4r+my/n+WNm/85tExeYJd9sUaYprwN/tf8Yisp
	 QVFDCRUO0E5h8SVU+7iyxI5i9oO2FPp61lg7vkE9tSqBdBacuhNs7tp0H7MNtVNFfi0x/
	 vdCw0ofxxCp12n6ZwkjYTNsfYI3yPcEP9/98bDMcObrJaghEoWre6T+Gm2FDKXtTkkYiq
	 E1DGG57kiOxNSwOZzCwU9IhGwgOXiWDsZdeG89oPUa44j0g5kEQwRgUx80GHJNf5N17xP
	 d11OrfAuq0prxy5QWsYuL/tRCSv9NOObHpVXAN8m/p1IB3TUT47i3PjQUTFA/yzjssQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=q6NQNifp;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864F5606A32C
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 864F5606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=q6NQNifp
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 056F81655;
	Wed, 18 Nov 2026 07:21:40 -0800 (PST)
Received: from [10.0.136.98] (M0PRX50XMG.cambridge.arm.com [10.0.136.98])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E080F3F632;
	Wed, 18 Nov 2026 07:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795015302; bh=76znSBJc2MSMujm9wkdMEo/eAgEApzkyxUKLENpqmYo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q6NQNifpKDBnQ3mzfKBpqSic+7ivC/QIQPC9ZqAnzIiw3mY9M0f4SfeIWexA8jr8F
	 YVxKe5qgrIUkYDGjG40ymcooh+4bIlbrZtmjGjNKtA5FDfOd/6J6hGJg6tdWzjMPXm
	 an+wTlCjpuZtgrS1fXDq4OyDJNB3D/NnKvX4qb/g=
Message-ID: <2c838d48-a7f6-411a-b714-f10125e90c53@arm.com>
Date: Wed, 18 Nov 2026 15:21:40 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v4 22/23] arm64: Map PCI MSI requester IDs to the
 GICv5 ITS
To: Vladimir Murzin <vladimir.murzin@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-23-sascha.bischoff@arm.com>
 <195b1140-c997-4d18-80a0-a0f4ed918606@arm.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <195b1140-c997-4d18-80a0-a0f4ed918606@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/11/2026 14:56, Vladimir Murzin wrote:
> Nitpick: maybe it is time for switch 🙂

Agreed! Done, thanks.

> 
> 	switch (irqchip) {
> 	case IRQCHIP_GICV2M:
> 	case IRQCHIP_GICV3_ITS:
> 		_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
> 		break;
> 	case IRQCHIP_GICV5_ITS:
> 		_FDT(fdt_property(fdt, "msi-map", msi_map, sizeof(msi_map)));
> 		break;
> 	default:
> 		/* No MSI */
> 	}
> 
> Cheers
> Vladimir

Sascha
