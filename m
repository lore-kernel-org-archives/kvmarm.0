Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E742DCC13;
	Mon,  9 Feb 2026 15:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770652303; cv=none; b=d1VaZoet3CiEP9UGqs4uRRgSINmi8pbbjH9ek5/Q7/9z/t5Q7hB+reU3raSSyw+/zMw3KvC6lK3mZcSblHUk2mwMlFPL0QqivYPwa8R4XNnD9I5Q2Fy3sXLBNWTvp9EyxCIeNPtuBYmslZbrxLREYUA1MX1YBY9xD/iW7ALwYJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770652303; c=relaxed/simple;
	bh=4KyBJAD0UaWWubG4V1cG69fxeT1HLs5rxEY/yGjKBsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2ZRfjwHkDqlNiA/rvNE48MQ5t0L8N2xDgvNAsEn2LTIecjQBeD0wsOpz5BPHJL0Qi/iCuP81aQDtG1VDWz7LBOeXz/VFH3vDlvY3ZD3I3UEtcAbSnLOPB3s2RJjAGL5qKpw3eTY6U9MBVWgtRwD0qLjYoTSKDZiYeLwLIAvhOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ssdALodG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ssdALodG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E028C116C6;
	Mon,  9 Feb 2026 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770652303;
	bh=4KyBJAD0UaWWubG4V1cG69fxeT1HLs5rxEY/yGjKBsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ssdALodGlJWSH+55SO7vbVKQvkUiD/1h+h/CMHkrMwy8/SR6Gjp5qIe2wi8C8aWRm
	 cMpwVqTz6EUwlrqvlgJbCanxJ3dR9KR9rSyymlSTjVOcsqrNT+dmZf2e0LwVL60puJ
	 JZiAuA3dO4ILW4ioYMiDt/hqVopxjqhmie8ZvE1ajk7pAukK9n3Q/ve7DzyBdEHMWU
	 c8/7CypGykPpvZPzFj8wMwi7h3HSEEN0kn/XtfUZxxRYslr9nuU2mG3QyGvCJVe5Fr
	 2YX1SdtPg5hRY+Om76D2hNToa+u171LquvXD4v4P/ZZe/aRZ4gjMgpicu8jQ/xOG2c
	 5HU33CtwQmUZA==
Date: Mon, 9 Feb 2026 15:51:37 +0000
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, maz@kernel.org,
	oupton@kernel.org, aneesh.kumar@kernel.org, steven.price@arm.com,
	linux-kernel@vger.kernel.org, alexandru.elisei@arm.com,
	tabba@google.com
Subject: Re: [kvmtool PATCH v5 02/15] update_headers: arm64: Track psci.h for
 PSCI definitions
Message-ID: <aYoCiXg8pSC_bwIv@willie-the-truck>
References: <20260108175753.1292097-1-suzuki.poulose@arm.com>
 <20260108175753.1292097-3-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108175753.1292097-3-suzuki.poulose@arm.com>

On Thu, Jan 08, 2026 at 05:57:40PM +0000, Suzuki K Poulose wrote:
> Track UAPI psci.h for PSCI definitions
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  util/update_headers.sh | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/util/update_headers.sh b/util/update_headers.sh
> index af75ca36..9fe782a2 100755
> --- a/util/update_headers.sh
> +++ b/util/update_headers.sh
> @@ -37,13 +37,16 @@ done
>  
>  unset KVMTOOL_PATH
>  
> -copy_optional_arch () {
> -	local src="$LINUX_ROOT/arch/$arch/include/uapi/$1"
> +copy_arm64_headers () {
> +	local uapi_asm_hdr="$LINUX_ROOT/arch/$arch/include/uapi/asm"
>  
> -	if [ -r "$src" ]
> -	then
> -		cp -- "$src" "$KVMTOOL_PATH/include/asm/"
> -	fi
> +	for f in sve_context.h psci.h
> +	do
> +		if [ -r "$uapi_asm_hdr/$f" ]
> +		then
> +			cp -- "$uapi_asm_hdr/$f" "$KVMTOOL_PATH/include/asm/"
> +		fi
> +	done

This doesn't make sense to me as I don't think we've ever had an
arm64 uapi/asm/psci.h. You presumably want linux/psci.h (which is what
the next patch pulls in), but then I don't understand how that worked
with the change you've got here :/

For now, I'll apply the first patch and then update the headers to 6.19
myself using the current script (as other folks need them updating too).

Will
