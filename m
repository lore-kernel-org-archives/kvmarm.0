Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0818E46EF62
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 12:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786711019; cv=none; b=DtJlLlZEl//+ZNGPcaZ0djCT6M8ro/r6x1qNbaIIr97eki/FjuNBcf/TQNjn7nzo14mzKEhuAqXtV2MJ9DoH4628a2hyYStJJT33mSkiOq+izt70HSQCeILu6bxNAaITDvBB5nIai2KON4juDCXsfoWhsrxlqE61qQV/wvPb5ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786711019; c=relaxed/simple;
	bh=h7kMHt9Pj5LSmpdo9z3BjEMgYsEGCc4t/gD2OSYTvcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mCSzI/uGBW7j4uVU3ecakWzJWSGZ+eiKJFXBGzf1oGjNWAL8jezoRNdNdRbtMm/Sahk7au9dk1BzGxLivkH+3RmGa+jQUZ4KNvtoU4OLqDp5ENSs66TVGv6EuF9JbFuPcoew+iDwnL2drI672dK4ROSGFuLE9YdHhK931csOfCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ce2AeaoJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ce2AeaoJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786711007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z+bad5oyeWP0/0ZF4aAZkwQilG4UExN8XIo8ZjKwl5Y=;
	b=ce2AeaoJEUE6cG9xyyTL31L7doqqg/w/OVsEBaHvc1tuqrXUg6czOPfF2aHZApGhrJpI/H
	sYfci31QfcqSo7jGdBSiqOsFll9ZqlEGbG1sPta6htWz6uNAWZjPmh6Yam1oTVl+XR7zA4
	sJZc+y0tO2V2FRdaOOqUVF8DWC7hMBg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-iL4hSs4rMhKQfO9sLGsz5Q-1; Fri, 14 Aug 2026 08:36:46 -0400
X-MC-Unique: iL4hSs4rMhKQfO9sLGsz5Q-1
X-Mimecast-MFC-AGG-ID: iL4hSs4rMhKQfO9sLGsz5Q_1786711005
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4954b1c6310so9385365e9.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 05:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786711005; x=1787315805;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z+bad5oyeWP0/0ZF4aAZkwQilG4UExN8XIo8ZjKwl5Y=;
        b=gGSjlSUyDl30SjCKfzQf/ju9CRqrcMB46QKEPxVNhQ7zpKmYywYHCzpCML0AD47cj1
         yKBM0x6MGqL3GcLfKtVHSC3XoT7kWJLD5BcnVP5+ltYDbRMLX92rn6Ky34wO8uetm7ni
         L54zXyXMkHSGePthkPy4tDlJO+tdEFX+UJBtucQAglSosmYAzJ1enHZyWOftABFSWrLU
         0u9JLAdnz6BqGc6H07NqLScrAy2yaaq7mggXhf9efc6sczMPAYLiJ8D86MhbOf/RtCIP
         Z0lXzB9cUMXsJIowowJMzCE5zT94L55J4pYWKb+xPTtwFDTrn1LUc/rUNYVyYi0sMS1A
         z4fw==
X-Forwarded-Encrypted: i=1; AHgh+Ro2F64zJ6JGpJjxm3KeSVK6VhiT//bDUu8LtK7ZU3kY+j5XELw7sIb4xszjc7TAcwwgny8BRM0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzE/rCIAd6R0jQj3NZ1gXMf8gpL4yFZF4/QoVIsijYZsJ/tXgr4
	StmJuk86Y57WkNxWf7PTfSaR7gLIKK9X0BAiOFH/N/6lRv+juIHFBE54eGnRZ8AVGP8f1tVCylp
	eSe8lVKKUAhJNcO5WucOg200YGz433oxBw95xWaOipQ8KXq6XkZCq7dnUoA==
X-Gm-Gg: AR+sD13mqbV/J7km4e/t5fcjfFcp7ZLiZjebNy9jJ/327hofgOk9CIXh6v9ecsROsXO
	I2bKaVfLAJzMZSV5u+/1CfLrOb56nai2OkwwRytdRVkmzdsOcwEHT8JBqMUubPv3ObIWdGNaYZ+
	7IN1dW4sCf3X6aWqEUfDmxSy5Jk4q2AEiva/D6il13FE307z3GveMhEZwo5QFtbYa/V/OUC676L
	wUV5rFkB/2D5GEzCNuhZXvhsCcl372YY39Qe0eIR3PNHELavuJEXgygHaSC5omLnAtMmqh2DMau
	xDxuHrF1l0bTPWJx+yEqVpp0SW+weAPJOlN+K/X9IaFd1H/3NCjtdnw7hdp3FH5WSmYyF+mBAr5
	MJePBq8H08mC8dbKXR2CxQqZFsM80mSaQGv2Fzvle1po=
X-Received: by 2002:a05:600c:3e15:b0:498:ee7:e407 with SMTP id 5b1f17b1804b1-49987999622mr78583005e9.17.1786711005077;
        Fri, 14 Aug 2026 05:36:45 -0700 (PDT)
X-Received: by 2002:a05:600c:3e15:b0:498:ee7:e407 with SMTP id 5b1f17b1804b1-49987999622mr78582165e9.17.1786711004715;
        Fri, 14 Aug 2026 05:36:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49989ae96c1sm25906085e9.12.2026.08.14.05.36.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 05:36:44 -0700 (PDT)
Message-ID: <0ce5e496-a067-48fd-80d2-94fe9981d505@redhat.com>
Date: Fri, 14 Aug 2026 14:36:42 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic-its: Don't dereference a NULL
 collection on ITT save
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Sascha Bischoff <sascha.bischoff@arm.com>,
 Sebastian Ene <sebastianene@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
 <20260807104102.2410744-2-fuad.tabba@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20260807104102.2410744-2-fuad.tabba@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dTdp6OnY93IY2to7W6iucbjjFUmTD0pwLJBjCU49oUI_1786711005
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 8/7/26 12:40 PM, Fuad Tabba wrote:
> MAPC with V=0 drops ite->collection but leaves the ITE on the device's
> ITT list, and vgic_its_save_ite() dereferences it unconditionally. A
> guest that issues MAPD, MAPTI and then MAPC(V=0) therefore oopses the
> host when the VMM issues KVM_DEV_ARM_ITS_SAVE_TABLES to migrate it.
Thank you for fixing this bug!
> That sequence is UNPREDICTABLE per the architecture, but KVM already
> handles the resulting state in the translate, MOVI and DISCARD paths.
Maybe: "its_is_collection_mapped() already checks the collection is non
null in translate, movi and discard"
> 
> Save a zeroed entry, which vgic_its_restore_ite() reads back as
> invalid. Skipping the ITE instead would leave the ITT slot holding
> whatever is in guest memory, and restore rejects an entry naming a
> collection the restored collection table does not have.
> 
> Fixes: eff484e0298da ("KVM: arm64: vgic-its: ITT save and restore")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 36ab3e4929154..ed281fbf008b9 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2119,6 +2119,14 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
>  	u32 next_offset;
>  	u64 val;
>  
> +	/*
> +	 * MAPC with V=0 keeps the ITEs mapped but drops their collection,
> +	 * and with it the ICID. Save a zeroed entry, which the restore path
> +	 * reads back as invalid.
in

https://lore.kernel.org/all/CA+EHjTymdanCKoQO3ATmUZ=7Ph2wv4ES8SfkSsTgmOYAYBWayQ@mail.gmail.com/

you also mentionned this can also happen on clearing
GITS_BASER<coll>.Valid clear. So maybe don't specifically focus on MAPC
in in the comment.


> +	 */
> +	if (!ite->collection)
> +		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
I would rather squash 4/4 here to emphasize we are unlinking that entry
from the scan chain.

Besides I also wonder if we should directly remove those entries from
the &device->itt_head on MAPC and GITS_BASER<coll>.Valid reset.

Thanks

Eric>  	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
>  	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
>  	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |

