Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AFF39023C
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 03:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789011628; cv=none; b=GUKN0Bta+MM7/JNGH869i1TovDqoqYh7QnDR5XpWADLchQ5hSCvUggL63CZuxNt4JcGUjZVsoB+S4T2+tyYS/VPrJU1lMra4ugadY6T52JSunwxWaRaJPlNZ0gLS4AIjRODby3nS4vhD3WXpep0890wtEh9u2saRgIpKNWKtHnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789011628; c=relaxed/simple;
	bh=IkdLP5CMbNSeQcg1JlhjuFap/uVykSyWKF1wsJxcwHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iSRGnKFRwR/GVJP0zs4MkwPBI9Gmfq+WWkruOAxYEVhN+7qC/YE13VuL2QB3CBNc1jV2k02sJEK2MVwp1oxI41AQ3UBsQx7bDWwcD3I5AmFYFT+dHw+YoFGFQ0xy2YgcmGYcJecfqPUGrrYOuEJC9II8UumvsV7qVSLcSVRUFuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RyD3kQyP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RyD3kQyP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789011625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/RRjDlW0kox/juFkyRROqpQ/BAv5W8k8xAzyOIl9/BY=;
	b=RyD3kQyPq+QsUEFEVzhy5adF8PtlPWFDvGro5Gjb2Z1IoHUf4VCiFqIL3CFKdtDiprIYM2
	O5PKVwciGBjxcclrY+pE0t75I4jWZHvsCQ95tVtD8z4wuc0MP3VN975pnuexZUS5HBklFz
	I7eV0UpUQ6js+BxK/l/299VKyl8iKDo=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-lYcrUfniMPWCjoqkQHYaag-1; Wed, 09 Sep 2026 23:40:24 -0400
X-MC-Unique: lYcrUfniMPWCjoqkQHYaag-1
X-Mimecast-MFC-AGG-ID: lYcrUfniMPWCjoqkQHYaag_1789011623
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc132709c76so9168864a12.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 20:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789011623; x=1789616423;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/RRjDlW0kox/juFkyRROqpQ/BAv5W8k8xAzyOIl9/BY=;
        b=OAUSQOYRwZQ2yaa8fPwr1yk/VTFqHgHQWMN0QsYa/Ux2JkGWxKNUMYtfdyZntZybbL
         BuB/NZOqJTnVaz5gzmoVHmkpVHsUJAKYC8oHpSYvbd6fSWjWQA/+/0/YeIpZ2e8wKSU4
         Nm3fpb8zu4s5bGRUCtxtOs+3RyMZF0X1ney5cObv9injmPoLaB8T78ju6jhwPdGzPkKN
         DyUKmPFy+EHege0KVt9dKhB2yQUxs9YXuFl4Tpmo0tXR68NaSmIYZfbk/Mmi4F5/lk0k
         afMp7A56CcwaGthIw4exf30WLI9rYcqljPttrd5twMMKqP5qmdORrG3Ywe/Z7fxFk1XW
         eh0g==
X-Forwarded-Encrypted: i=1; AKwUvBzCEJ6qdLfdyZRWu2z+c8MH+a6i7kFRqbQd5uy6qpGCMZvE/kjQPAZbaXx615G8/KUUuXBdmBg=@lists.linux.dev
X-Gm-Message-State: AFuF++lrAQ4fMkYLNCJ+O09LpmAHwfDNX8w5HJsxGsk1ZIPo21Y8rWz3
	nio2sFg8QZfXamzN7GGIE5DyIOVM5wvjR/rO6oGcFPDRdriXvUDeLevlC3ghfSnV6hTg3yBflss
	m7TN7sCqHAzA1MJ7Cz8D1lBUcNokhn74ILeGqoKXFVsEJcE10tF8KSszT2w==
X-Gm-Gg: AYBFou0JLHpDKK5gDfjbFl+cHdmYgXYhzjoKku92kceRNnwc+K7m75rU9w8yEyJnhPB
	PNSNksX867WPYn9bIyCmFCj7kEa72z6f9qcYc22uAe1lInaLesYWNVSVu7Rn7BtWqawMhNJB53f
	9ZVmQw4D4xLvsDCDzJg3YOMSomWZk+unsOl/ktrW+jbZahHqcbRWaOrhAYtomhKmwlVsKnEcOKV
	nAx7i36t2qAkWSd/10f9FTk6kB049n0R/mAP45Pwz5S95WXDThPj5Igmq2dAZ3/yV5OaeycRHbz
	3ddhbvgvMHu+At3HrwOexeMQUBW/8IQVMId1GSWKlLG/Ikd4WFEvFIhRZE3lgsPHIRGPf0eNhMy
	RUN61rnHH67gqwoy/ILSx9JP58qkzuWzJnSof1AN/XA==
X-Received: by 2002:a05:6300:85:b0:398:8870:b58f with SMTP id adf61e73a8af0-3dacbeed903mr8426018637.14.1789011622917;
        Wed, 09 Sep 2026 20:40:22 -0700 (PDT)
X-Received: by 2002:a05:6300:85:b0:398:8870:b58f with SMTP id adf61e73a8af0-3dacbeed903mr8425945637.14.1789011622523;
        Wed, 09 Sep 2026 20:40:22 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4aa39f605sm1053235a12.21.2026.09.09.20.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 20:40:22 -0700 (PDT)
Message-ID: <f24104a3-fe2a-4a71-acbc-a4c3d2d416d7@redhat.com>
Date: Thu, 10 Sep 2026 13:40:10 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 02/20] KVM: arm64: Avoid including linux/kvm_host.h in
 kvm_pgtable.h
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-3-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260908162223.1683432-3-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wEhXoFzH9xax4Fhcnq-rbDzzBFOPioU8Q-oRhtBMk6k_1789011623
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/26 2:22 AM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> To avoid future include cycles, drop the linux/kvm_host.h include in
> kvm_pgtable.h and include the lightweight headers required for the types
> and inline helpers used there. Additionally provide a forward
> declaration for struct kvm_s2_mmu as it's only used as a pointer in this
> file.
> 
> Both pgtable.c and kvm_pkvm.h relied on the indirect inclusion of
> kvm_host.h, so make that explicit.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch in v13
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 6 +++++-
>   arch/arm64/include/asm/kvm_pkvm.h    | 2 +-
>   arch/arm64/kvm/hyp/pgtable.c         | 1 +
>   3 files changed, 7 insertions(+), 2 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

