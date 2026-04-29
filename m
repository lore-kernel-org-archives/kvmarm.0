Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2DA9463;
	Wed, 29 Apr 2026 09:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777453442; cv=none; b=SUjq8MA1aWrZNvXM12UpJWl9A9+ATUmxRwGNiGUQl6Cy+A5b5fo0JV5JeyTp8iDeiGPdm1XXR5jyCLxNvjq9rA5HLYSD4HGfNLPdYsW5eEmhWl5UCDBovbhmLOwmrXdvJCfhg/6wIlC2JcxWjSkI56oXFrIuIhzEw6h5cARyODw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777453442; c=relaxed/simple;
	bh=GlS0SwwAWXqWj/7Jc6bpwhH0bZk5wVaKJDdB02OB62g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tiZDLQd9pyasqtFzEOg/XCig4E+bwKq+3o7e1aSHQ0znceJG24oyGUTSyPGrOQEOggzyi8zQCZNCMMYOpL9AFk2nGOwHQTTYcRQlnLBuIMEm4gF1KRB/ARwj2hARkQzjYeVNdCK09etqDKJNFBirxwUWeph6EC2HEbx98iE4v+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ti93xAMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ti93xAMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8E5C19425;
	Wed, 29 Apr 2026 09:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777453442;
	bh=GlS0SwwAWXqWj/7Jc6bpwhH0bZk5wVaKJDdB02OB62g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ti93xAMiLbMaMHonvVmLyQT0uIvkTKlNv0xaRHEBxrmRd5VjIbPfZ0KEU/CG3fqs0
	 vlnllUSlrwer2rVn7Kl3nhYyUcx3v5S7CfROlsqqxPItkeVidgYkXK76GUED4eCvPH
	 6BcfYEYaVeND0Z4goX05clzzSvaa0RM6z0VaqEbSg1cn4G0Zp9v0d2M212KLJT0TPi
	 6klFM3hjhapurXuRWCbRt6LrBEgFl79/ud5WBEC0jvWoFgjtxXqxquMHHAv8OA8YgN
	 bX/MRcupcMSUOzl9JUYQ+HDgsbahChlb6L43dRAtf/+q93ztefgKUHrA4iIXQR0upQ
	 9miKEWWI8iQDw==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, sebastianene@google.com
Subject: Re: [PATCH v4 3/3] coco: guest: arm64: Query host IPA-change
 alignment via RHI
In-Reply-To: <afC8hZTJY6Cx8Liz@willie-the-truck>
References: <20260427063108.909019-1-aneesh.kumar@kernel.org>
 <20260427063108.909019-4-aneesh.kumar@kernel.org>
 <afC8hZTJY6Cx8Liz@willie-the-truck>
Date: Wed, 29 Apr 2026 14:33:55 +0530
Message-ID: <yq5awlxqyw78.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Will Deacon <will@kernel.org> writes:

> [+Seb for the ITS]
>
> On Mon, Apr 27, 2026 at 12:01:08PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> Add the Realm Host Interface support needed to query host configuration
>> from a Realm guest. Define the RHI hostconf SMCs, add rsi_host_call(), and
>> use them during Realm initialization to retrieve the host IPA-change
>> alignment size.
>> 
>> Expose that alignment through realm_get_hyp_pagesize() and
>> mem_decrypt_granule_size() so shared-buffer allocation and
>> encryption/decryption paths can honor the ipa change page-size requirement.
>> 
>> If the host reports an invalid alignment (when alginment value is not
>> multiple of 4K), do not enable Realm support.
>> 
>> This provides the host alignment information required by the shared buffer
>> alignment changes.
>> 
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  arch/arm64/include/asm/mem_encrypt.h |  3 ++
>>  arch/arm64/include/asm/rhi.h         | 24 +++++++++++++
>>  arch/arm64/include/asm/rsi.h         |  2 ++
>>  arch/arm64/include/asm/rsi_cmds.h    | 10 ++++++
>>  arch/arm64/include/asm/rsi_smc.h     |  7 ++++
>>  arch/arm64/kernel/Makefile           |  2 +-
>>  arch/arm64/kernel/rhi.c              | 54 ++++++++++++++++++++++++++++
>>  arch/arm64/kernel/rsi.c              | 13 +++++++
>>  arch/arm64/mm/mem_encrypt.c          |  8 +++++
>>  9 files changed, 122 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm64/include/asm/rhi.h
>>  create mode 100644 arch/arm64/kernel/rhi.c
>
> [...]
>
>> diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
>> index 38c62c9e4e74..f5d64bc29c20 100644
>> --- a/arch/arm64/mm/mem_encrypt.c
>> +++ b/arch/arm64/mm/mem_encrypt.c
>> @@ -59,3 +59,11 @@ int set_memory_decrypted(unsigned long addr, int numpages)
>>  	return crypt_ops->decrypt(addr, numpages);
>>  }
>>  EXPORT_SYMBOL_GPL(set_memory_decrypted);
>> +
>> +size_t mem_decrypt_granule_size(void)
>> +{
>> +	if (is_realm_world())
>> +		return max(PAGE_SIZE, realm_get_hyp_pagesize());
>> +	return PAGE_SIZE;
>
> No, this should be indirected via 'struct arm64_mem_crypt_ops' because
> there's nothing particularly unique to realms here. For pKVM protected
> guests using a smaller page-size than the host, we'd presumably need
> something similar for the ITS (where restricted-dma isn't used).
>

Sure, I will rework this to use struct arm64_mem_crypt_ops in the next revision.

-aneesh
