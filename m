Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DC02405EC
	for <kvmarm@lists.linux.dev>; Mon,  1 Dec 2025 23:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764631021; cv=none; b=p1ykOSLWCgGFdFh2NoD5eXJtvMBH3t9OMfPIPalnYIVmAB776rgrkUSqM0NwZyszQAByaz6w8tEqShv76++qjZ2oT0SiTSu/hxgKbNmOGngbj6cohyWTKbbDU2NeOO/hJYEdbwkpsWuEzRKZ4CMZzTkulqFtjFxYYWjJn7FxC+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764631021; c=relaxed/simple;
	bh=+lp93F6g8ek3RZ5nct/4V2jvnmStEmVEqjnyd/VFMow=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gp6HrPsD6QprqD+ItB92X07xsQX+x1gMkWmOf8LT6/Nij/AG3mAhIMPWRAicZH+FjBDXJtHu8GpeBCuUbTi8z70IYBKyLZY9colBzOZcILVch+r1V4TVgqZat0W3dcR9bvxnnd9p9/2hjFrmtn5zsyGx40Ig0kgjR+1HeaB0tfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQMLZ/pQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQMLZ/pQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764631018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w2JiQvYh5sm4dF/Ad/H8RwiLEUsI3vXlerU2PyyWqTY=;
	b=hQMLZ/pQI60tkJ1x7Uj/+IblZu/UOSmcIXpu7UT+VgBTDu0IDC0RHpwi5uvuj4VGpZWok4
	trba6cDBX2llSpSeJjMGuegh61qdSAi6bUgWKRTsugdkuPpYV5aQ7Onb4UpYqBR0cIl9rG
	Ez2PPqS3w67+HDf7VCK7TZGxVOcbJbk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-va131d7kMQiSKewDqAMliw-1; Mon, 01 Dec 2025 18:16:57 -0500
X-MC-Unique: va131d7kMQiSKewDqAMliw-1
X-Mimecast-MFC-AGG-ID: va131d7kMQiSKewDqAMliw_1764631017
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29557f43d56so52011815ad.3
        for <kvmarm@lists.linux.dev>; Mon, 01 Dec 2025 15:16:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764631016; x=1765235816;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w2JiQvYh5sm4dF/Ad/H8RwiLEUsI3vXlerU2PyyWqTY=;
        b=dddjU/RDxNsRJSbJT9MqpSWnNnFNXCZSVUuS9/w0/aeS53I3cM3lGAIxb8TR1pLE3O
         mLp3QgCS57aUxSuI1UyHWkNzi3itJ1bKR5k+DtjJGl0GdnI7YtrrOvV+7sXpjvFLUvT3
         BVz0n3hk1IJCKSbrP7KCJHtgwJfNA9FJ1pTWUp/ckoCbeZF009moZnK0cPzwXJ/lx82X
         lSEn22WDmvG8L2BeihOAuHeL9a7Jgz2q19NVecNxOtMpMFlsLQFvfJr5pQuSpRci3NhG
         9NxwSDqEaOCrgH9YkeufP84Oe1toJX+y5qeqmVn2mft8QJfkjrUN7LihXZCohx0oeQTF
         TUMA==
X-Gm-Message-State: AOJu0Yy9bpdfUZ4kHCQ0D9IeQEKibqQmLlesDc3/JkOPagnWCgG0HDiC
	vkdFrltJqIrDTaZdTE10yOBDicFNnFwutJO3mswU0JYI6JWjQ1hppmCvhotLdjNHrwMmTlxDRar
	/e1WL1GJTrtMZCr5sL+N8b1jUAkMp/IJRgtpPoMmb3Z2Gw3YeOqQH9/S2olx6TWlCYwPb1lzW1/
	nfvjFq/TPOJr96oeHz24yJTFOqS8XWQ5lfKtyXJA==
X-Gm-Gg: ASbGncst06x7s9lgbXK/sUNqeeNm8YSBNwxCySJWyKw2iXDJbAEv3YhRlaoCusZytCe
	M8/EtmbOgnYJpb2ZXloswz8LEVRiH/yUOPSND1F6RA7bRuhCM9uNECoVQyVLcORG4rnTauNsQe9
	OEl8SWd1H5JC3/Ij+yiwrOK27ogsuOpe3zr2mT6BKcVuJikl2zdIjRnj5/nmjHe8MUFzBvl96Vo
	x+ZuEtfIZlD0IgFarYeLLMP8mjyDTcnz/oq2+qPsA8wBqRAihnG/B5qagvPaoMUUyHmjsthIO35
	w+wtm9MrV8D9QXepmzHxvtM/2Y8j/9hzNkg9wH1MuEZQPe/XOD5UQDMN63XxnjG3KmD77lDAXiq
	mERSmUbgWWeLxSOJnFK8ddBPpM3DFm4HYKuSvI/tFJilzuyNBPQ==
X-Received: by 2002:a17:902:fc4f:b0:29b:ab3c:83a3 with SMTP id d9443c01a7336-29bab3c8498mr289489515ad.5.1764631015702;
        Mon, 01 Dec 2025 15:16:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFyevsaXlVkZQPgAl9fthr313SLT72+cWZt8TDFYWvlLYtQ2urgXFCv6ronYdUQmllLwTzXA==
X-Received: by 2002:a17:902:fc4f:b0:29b:ab3c:83a3 with SMTP id d9443c01a7336-29bab3c8498mr289489255ad.5.1764631015302;
        Mon, 01 Dec 2025 15:16:55 -0800 (PST)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb27504sm134068245ad.61.2025.12.01.15.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 15:16:54 -0800 (PST)
Message-ID: <1c1860a0-91b0-40fc-acd0-97f04e6b3851@redhat.com>
Date: Tue, 2 Dec 2025 09:16:49 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Fix core dump in rseq_test
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
 seanjc@google.com, shan.gavin@gmail.com
References: <20251124050427.1924591-1-gshan@redhat.com>
In-Reply-To: <20251124050427.1924591-1-gshan@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T2w5AOCcgglp_mG1yhoTTSEBgliRiSwTLIQc5T7N8Wg_1764631017
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sean,

On 11/24/25 3:04 PM, Gavin Shan wrote:
> In commit 0297cdc12a87 ("KVM: selftests: Add option to rseq test to
> override /dev/cpu_dma_latency"), a 'break' is missed before the option
> 'l' in the argument parsing loop, which leads to an unexpected core
> dump in atoi_paranoid(). It tries to get the latency from non-existent
> argument.
> 
>    host$ ./rseq_test -u
>    Random seed: 0x6b8b4567
>    Segmentation fault (core dumped)
> 
> Add a 'break' before the option 'l' in the argument parsing loop to avoid
> the unexpected core dump.
> 
> Fixes: 0297cdc12a87 ("KVM: selftests: Add option to rseq test to override /dev/cpu_dma_latency")
> Cc: stable@vger.kernel.org # v6.15+
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>   tools/testing/selftests/kvm/rseq_test.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Could you help to take a look when getting a chance? :)

Thanks,
Gavin

> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 1375fca80bcdb..f80ad6b47d16b 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -215,6 +215,7 @@ int main(int argc, char *argv[])
>   		switch (opt) {
>   		case 'u':
>   			skip_sanity_check = true;
> +			break;
>   		case 'l':
>   			latency = atoi_paranoid(optarg);
>   			break;

