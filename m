Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBC22941A
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 00:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791245009; cv=none; b=JstcCySK4FL3/9B8tyzdtMeDG+N3d4PKVcOP9CpzBJXv2LzNIbEm6To50jDDvNGmt01cBhpeuSylLhl5Vx7vLRwP+m6RoMuJCAIPzPrXPJhaBOVRW1dNp4M3S0tlKSSTkak/AEcOsMbVT50R+fjLiUmdsmy3DEDh+X24CfQhPrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791245009; c=relaxed/simple;
	bh=r/xyKW/+NyCSyYJfFfr1Na2zRDCsUAkIxdQRW3XIkgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YZGs6b/CSVhSSGBG/8oUQcg35QueJXoUHsv4g5Zhf4+atcEYrLPMC99IQoTpoGmoN3EXo/5ygPtgHkmCKVRDPIHg8uBvK3QcFR1iXOD0dDd83A1av28HBsY1I/9xp5li0WaH+GGpS9n54Jo9XWCcPd55+8a6qSU/OLF0y04cokw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cNep+JQo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cNep+JQo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791245007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3isgNN8kiLtIbsG19uUxm1RN+HXpbBndqmLznSpT6Ig=;
	b=cNep+JQo4axXB+zS+kBdZCbLlodDSmYNKCYbbgyAUdqHB2hv4phi2K7+Ya2jUGKKxUKcTk
	dTk7Pt0tYZ38aYqcxCUsz14ttvpGW7yRjUi2k9u+WfeDv/AKdzfANCljwFW8ns4kL39cbn
	F+RuIuihirMcHiqbiyReq7ejXgno4KY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-Xv0AkxM0PSmuMXBJ1hw-nQ-1; Mon, 05 Oct 2026 20:03:23 -0400
X-MC-Unique: Xv0AkxM0PSmuMXBJ1hw-nQ-1
X-Mimecast-MFC-AGG-ID: Xv0AkxM0PSmuMXBJ1hw-nQ_1791245003
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-395543dc382so2197794a91.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 17:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791245003; x=1791849803;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3isgNN8kiLtIbsG19uUxm1RN+HXpbBndqmLznSpT6Ig=;
        b=m9cb/WBhwlZv+c24tV8Izbbpa4ELTxgSdP8VK0lHqxRVARmmhbGjDn2aICsbinIky9
         0/6zp79n6455CImQf8cgZ6DABC+6wKfSAc5mMnAHPOvSxCUlDfMswzN5e2uuyWkHjp28
         b3vFF8TQINBXZglj5oZpmGzpnGgMQ5KldrmralHc8umhfiBAPoluwVBNwMQM3pvru1c8
         m7XyLij5oPlYdkLy1teddUvFVRneLRXsT6oPxhYNu9vOf5NKpK5WPVkg6lNHhVrwj5Wa
         N8VtYfRWeUBwLgXAS0/KptzyuwunOa5G8DqRitPtHXH1CI1GSBiHEFYFJXZuNREfJCj2
         zJZw==
X-Forwarded-Encrypted: i=1; AKwUvBzmJiXHsb7zMlpo409JDH9mZijZxjWRQtolrVfVI3u8zYyixQGgOIOIlfTYbQbMEXN5fjJUxs8=@lists.linux.dev
X-Gm-Message-State: AFq9FYIN/1Wz7z21f5k3sIFef59EPPAafkFV3mwoXWHZDcE+CVwsJGpL
	gtfXL8o1UZiozNFf9fwx0RI9UtiiazcukOXCzl7s0IrxoMq5n/GsW0fjOkb3Fgz8y8uhd0VteI6
	6HdcCzb0AEVNjjUWLYGFk/y0dReW+UX+aXsplqMzjkXqHwQs+GzjQ2GRGjw==
X-Gm-Gg: AYBFou0s/4A7r6TkHC3X5YiTsWC2bNsZH+qax+c1A9YHg8ZQ8uKepkMWjdxRgrsWwod
	awarEdcQxm7ErKpcuX55YmAtbnEzyJ984/Nymp9TQdYb3O8NT00RvWT8tSB/V8G3D/t73iMqrzE
	Vseh+eLHkX/8NXXmfjX/jr6KcnJu7+EPYXV8dZfcQ6i9vWxj/cjGflnMfA8OShMjkhPlW+64Qrb
	Z8WGKOw4r+9UOi1q5q6Ezyo6hoHbVuqx9mnQovhunFVmc35zDUDfua8j6WmQXF4YZ58MM/KuUBt
	I/OGB5ZiiE9GktgKbKofYz9Q1Q6iVFjUsGV//2JSOeSPe1bfA9Q0ZlCp8CkoEJwhnLpRTR9ntN9
	N890uqNNX9qZGeDLGQg8iUPUT+QxyxwynPj9ERCsqXw==
X-Received: by 2002:a17:90b:39b0:b0:3a4:c8d2:6c2c with SMTP id 98e67ed59e1d1-3a6ce845d78mr5199380a91.49.1791245002602;
        Mon, 05 Oct 2026 17:03:22 -0700 (PDT)
X-Received: by 2002:a17:90b:39b0:b0:3a4:c8d2:6c2c with SMTP id 98e67ed59e1d1-3a6ce845d78mr5199369a91.49.1791245002098;
        Mon, 05 Oct 2026 17:03:22 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a6dcbdd97fsm8611158a91.0.2026.10.05.17.03.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 17:03:21 -0700 (PDT)
Message-ID: <7b196a7f-d31a-4acd-9f3f-a24c0e78db43@redhat.com>
Date: Tue, 6 Oct 2026 10:03:11 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 02/23] KVM: arm64: Disable Steal time accounting for
 protected guests
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Fuad Tabba <fuad.tabba@linux.dev>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-3-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-3-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0Fz3MU_kdRLB8nPF9NUG_kiv5xwdwFrTsZHr3mu0bCk_1791245003
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> PVTIME support is advertised by KVM_CAP_STEAL_TIME, which doesn't take into
> account the kvm instance. Even with that, a VMM could skip the CAP check
> and proceed to configure the PVTIME as we don't do further check on the
> DEVICE_CTRL. Tighten this up by passing the KVM instance around wherever
> possible and catch things early.
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 +-
>   arch/arm64/kvm/arm.c              |  2 +-
>   arch/arm64/kvm/pvtime.c           | 14 +++++++-------
>   3 files changed, 9 insertions(+), 9 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

