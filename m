Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADF4357A3E
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 01:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558941; cv=none; b=lLXd9Sp9kdP4NHXhbnvAC33D0Y4t5wpelGxxvLHnZ2lZcjLXzT1ZgfO522RjJSmU9aqT/bXtRQ6ZerHmj5mR3baZ/4yVibMUQcR9Q9Yj7eT47YYmXsWUf4shDMkE0qEn1X8VhyB5w6KLP6Xppjuox965+PTb/4yg2//JFFCTaNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558941; c=relaxed/simple;
	bh=K1Rn6LESGV/7OPV/x6+LGZKGuG6ZqQ4flZrk7mZ+2JA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RLkbTbfWLSfsbCtoJS9yuG6eeCr2W10bQESIFnUcDln8TLw4Dj7YTFJi2Jfb3CMCmi8/s+iUM2rqSnNnBFJwP3RtfX9iNjJFP2zfyKhVY6gRVeXyoBHwx8xr5le8PS6fypFgsVpMfzD0PqOj4+FOBDCE7j8YQhTkGwQRiBVVWrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AfaSuEIV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AfaSuEIV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790558939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q/Ho7D9pnwA8vFx1jX3g6jxL7io7VVBJIDHq0PV6nYs=;
	b=AfaSuEIVJYhxPBIxTIrDwUHaMLcI6NEa17vPc5mvpFDD5qWE3pNeG17tzoj0qcjB/uWJgY
	+tGeCN0hbHECiYG488GOen35HYexvfXu8WAE3+RnKyrJa1N6zokqJcgj5G6onaNJeAVOzL
	igjjE4nqiyy9qQf2gI0/EeVK/S5Dvtc=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-Za_kR8XoNMmhJw1D91PbGQ-1; Sun, 27 Sep 2026 21:28:58 -0400
X-MC-Unique: Za_kR8XoNMmhJw1D91PbGQ-1
X-Mimecast-MFC-AGG-ID: Za_kR8XoNMmhJw1D91PbGQ_1790558937
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2df8d1e91c9so37722315ad.0
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 18:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790558937; x=1791163737;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q/Ho7D9pnwA8vFx1jX3g6jxL7io7VVBJIDHq0PV6nYs=;
        b=2u0PqOt2fIbelh8ZQv4lV60yStWJeUtdQzFXrqR5v/D3R+m8EH94rvGZ+HDCH7zECX
         b469y7yVuoS/x4JxBIoCCJOAwvgYLJXY8pPd5VuKbQLDxCq+0S3af95EMsTxxJ93iPPP
         RNjHK+p5FafW+8slvuxe6t6O5U/a7JssUd0IHjxlVhjz/8fEoxIJ3KBUxIZyAZ+NlIYQ
         Aq/xzt6BCzhmpa0ctFmz+iYQLCf5UcHsHkD38+9p2BBO5utWC63T2Tk4yzTgXN/xmiuS
         36TjlofOWFpOTnq1cn4akSa8+6gUcd4AjpTMzl+MXUhtqH7OwQ+dDwpR3ikjHNQvNTwx
         XhcA==
X-Forwarded-Encrypted: i=1; AKwUvBzW5LIrM6dgiFxtd7pSTBoar5Y5rHla2oTMRyfrXWxwMmbhnLSoXQeMKcAqV3O34053u0c2Dsk=@lists.linux.dev
X-Gm-Message-State: AFq9FYIDSK8k+r/1CzK4EAAayYSiWjmetpj2/GFnUUllclR2P7i5g0Vl
	md9DW97EbTwN2CyE/pDKMhdXmJKNDOT7c6ErVx20EaA/+UTUmJpGZjTsPzVe5MveL7cEae8zA/9
	GJg04zbuZmgxWN/e6DZYSmHTEtReFNn4oNMBOqlLZv2oY98swge/IBIHZng==
X-Gm-Gg: AYBFou3GEB3GohkO+PG8wUnEmar0YWtpRQceiSMPE6LhqI2jGcVgVP/S2qdfWYOoGsK
	wZbi11gHfj+jjv0PGgmjwZw9LvqzYGbOV6FHu93nHzX219y2I79AgOTQHjHPq4vfFh5oK4YogVL
	4k/aFCESS8NZlkqWAepagwyTD5oTVRHQeSIHP+nX0dKBaoaXpPqXwqR2sXkqpJCFZHSxuaZsFMx
	PGP37KVYaVWi9KsbslNLsCiyGtt9Y6FCTPlkrZbftxlL06LJntjmhAdEoSfSDS+K062dPOtPvHv
	vsylQDGLWbc7KTcmwb20r3HQtRMkNnsnYuuLsNcGeSs62cfg9n7rWKN8MvXEzEDAiF8ohP44tRx
	1tBN3yZ9cxrRvYn29ogLgIJSCiMwFpRLrEt008XPFqA==
X-Received: by 2002:a17:902:cf0d:b0:2e2:91f:40e5 with SMTP id d9443c01a7336-2e2091f44f2mr12401575ad.59.1790558936699;
        Sun, 27 Sep 2026 18:28:56 -0700 (PDT)
X-Received: by 2002:a17:902:cf0d:b0:2e2:91f:40e5 with SMTP id d9443c01a7336-2e2091f44f2mr12401385ad.59.1790558936289;
        Sun, 27 Sep 2026 18:28:56 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9142b00dsm33448475ad.49.2026.09.27.18.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 18:28:55 -0700 (PDT)
Message-ID: <699c086a-afb1-4738-bddf-54e98b8a3c34@redhat.com>
Date: Mon, 28 Sep 2026 11:28:48 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 17/20] KVM: arm64: CCA: WARN on injected undef
 exceptions
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-18-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260920212845.707-18-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PsCuCBiToK7OVmnq1UTl-G6_EY9g5F-ik8eeTQA6F-8_1790558937
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> The RMM doesn't allow injection of a undefined exception into a realm
> guest. Add a WARN to catch if this ever happens.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v15:
>   * Switch to KVM_BUG() to mark the VM as bugged as well.
> Changes since v6:
>   * if (x) WARN(1, ...) makes no sense, just WARN(x, ...)!
> ---
>   arch/arm64/kvm/inject_fault.c | 1 +
>   1 file changed, 1 insertion(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

