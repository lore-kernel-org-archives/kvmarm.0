Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AF52701B6
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 02:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254285; cv=none; b=naF3Ovb3LqrOxUDzC50Ydx8olomcvwhCAQ+lVs3X8MS57rdIXMxQqwpUB9KFzpkugb6o8Lm/Qo5kgXA2Pw3E4AGMdzfodIBzf0bHpZYfuZxb50JLhdzFLew0Cjb221FXaIgiCkB+wmzZVnSXpoxrW1yQIcnX+/fRmog21Ij5P7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254285; c=relaxed/simple;
	bh=D0UxWkrGDJEjJknTZwzjCJ31q1+uUyqqvfVL7rYvYbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KKwAn5nUM6pZk5YxwJbSm5rXG4EB9me1OL8UizMb9jyaQ9xUimuCbchWCaQRztSFb8XL2ShRB5XfYWB+kTtmLzPEo8pYBg0MJGYLn6utdR4d+Nm0c4VQRZ9a0QZO7bT+Xvr87tAxVngoSiBh6zfsjj4dS98IQiou5vSujmreLvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lnm6l3av; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lnm6l3av"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791254283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Di6epxlZpoHDGpBk057UhpR75wL2RoTA8HU7YmJFqJk=;
	b=Lnm6l3av5+fB7j47sNy48pyMAywTlleTPaCR5L2mUVYTfC2Efj3atyClZ9comRlwCNUzTZ
	sD2r6fzDyBGHIN5nDs+EqqdfpPQxOQmwdNLDZaXH0IDDzovjylf9woZVV8tBJCqEaztqTw
	EpavJe/W/UqEUWNRwyVYABFq46K1r4s=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-_QNPAjm-PgeMM_lZrsLW6g-1; Mon, 05 Oct 2026 22:38:01 -0400
X-MC-Unique: _QNPAjm-PgeMM_lZrsLW6g-1
X-Mimecast-MFC-AGG-ID: _QNPAjm-PgeMM_lZrsLW6g_1791254280
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso2192515a91.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 19:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791254280; x=1791859080;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Di6epxlZpoHDGpBk057UhpR75wL2RoTA8HU7YmJFqJk=;
        b=BHVjVleI6GJ8vjcWzAHWGvNWxoF5TWiJQ1w/Ii2m5BaMxZAkWYPedfSgw1csP9C2x6
         37lIssA6lmrXVBwQ0QgjwwgJMnTYLvY48DPhIqPT7TRpZh8zP65k1ZD/mPU7Z888wWqk
         lObPFn2xdlbN0zIckXdIILPmCJXzlaRL0NZmexIQQ5xjF/DAdAt+I0fJlC+WxZiTicaN
         6xzRtfUiUEr2MZCPKDQQijvDkw0bhMrPbQN1kr7D+fl+UvvKk4kzUSFzWltGfaTvkKVS
         eOBtHjylX3ikNwScr/qByhKZgoAk8kO/tSwUjRfvq1weSN/hMKWr0uwhwYxMckf/4jdd
         DEuQ==
X-Forwarded-Encrypted: i=1; AKwUvBxBHPNMAFdu+5LtjYGHTSx2zzCOs8Oh1zoDhw58GnF7f9W1Ae6D5jODH4sTq3YvqxPPEk58KpY=@lists.linux.dev
X-Gm-Message-State: AFq9FYLbnkNZo7F2XD3vru+Cs/P0Rc7Y1hm9+P0D27YVVdbinaylVuxi
	jvyhO/tTOr89eB13Ns7zzENa2LIvMnilaF1a/s+6XCMUhSaU/8oOZmF8EF+XQfza1DzKsrx5AtJ
	AQabFnmakpXbFBso2Gwodl+hE12dizpJRe5xTgkKtb4ip2ImxLBlCcJs/mA==
X-Gm-Gg: AYBFou0mjKCUn+hnFJHd9HL3IfpsOTh4TwEYx3YQL7Bsh67w/6Dpi9Bw8QKHkeCPQDX
	/NSOhqqBSS0A5/G8+vH9ywLawOBZLkFWfHhvQ2RWmbB/Q960B0LFMBZT3dgxJO4X8sqbv2pMcTc
	jHMnbapYlkSxW9tEU+jcHrPnd1plsoPs3SrNSgk2FMEkJwJQwGioB8ZKKOHrx7xdHh6cnWaIy4O
	Y//zo3K1B5jwcC35QbTdJVDJ2ryLbJygPatXqU8uHmr4pfJJx0rpQcS8FoH3QhZH4QYeGDIzItS
	qDH5RoluTpg41BHMVPX6zBpJzivv0EZfrgDd+4W0+M/jkSOv0F2soDjUk09jisPAgLau0Xucnnl
	0w/Tn9/SF/bag2H09hKlqmEqzBqi30ViE1O4NOW2vdA==
X-Received: by 2002:a17:90b:4d09:b0:3a7:9413:cfa3 with SMTP id 98e67ed59e1d1-3a79413ddc3mr6299022a91.55.1791254280371;
        Mon, 05 Oct 2026 19:38:00 -0700 (PDT)
X-Received: by 2002:a17:90b:4d09:b0:3a7:9413:cfa3 with SMTP id 98e67ed59e1d1-3a79413ddc3mr6299010a91.55.1791254279897;
        Mon, 05 Oct 2026 19:37:59 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cce6d2406b1sm1679514a12.8.2026.10.05.19.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 19:37:58 -0700 (PDT)
Message-ID: <c8930670-32b1-4f20-af0b-a13d17b45044@redhat.com>
Date: Tue, 6 Oct 2026 12:37:49 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 10/23] KVM: arm64: Consolidate stage2 unmap range into
 kvm_stage2_unmap_range
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-11-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-11-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rNmsdiqeZjuEkQuJ5h67GXsmRCXobyN3GOnbOj9gTmk_1791254280
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> In preparation for adding VM specific backends for stage2 operations,
> nuke __unmap_stage2_range() and fold the logic into
> kvm_stage2_unmap_range(). Also, make kvm_unmap_gfn_range(), the only other
> user of the __unmap_stage2_range() call the kvm_stage2_unmap_range(). Also,
> while at it fix the comment to make it clear that mmu_lock must always be
> held while unmapping. The code already mandates that and the two call paths
> do have the write mmu_lock held.
> 
> Later we would replace the logic in kvm_stage2_unmap_range() with VM
> specific backends.
> 
> No functional changes intended.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Change since v21:
>   - Nuke __unmap_stage2_range and consolidate the stage2_unmap_range logic
>     into kvm_stage2_unmap_range(), in preparation for removing the KVM_PGT_FN()
>     for stage2_unmap
> ---
>   arch/arm64/kvm/mmu.c | 38 ++++++++++++++++----------------------
>   1 file changed, 16 insertions(+), 22 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

