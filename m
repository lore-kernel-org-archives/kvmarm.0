Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477602D1F63
	for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749559146; cv=none; b=XBuM/Xz8bVBPMvrEEKcnTNdn73ChEASbS/3hlv1va3SWpdEwjdMtt3SsDGAYhxsUriQYDZUe3nTCXqkhVpPhjuAmVWeXH6Z5FRmHwc3qoPfzTdGI3RWyZQMOqckrVbeBYxuqQ6stDvEaPMwdVQuMYf/3hfbOloh1ZgJ/PEotWog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749559146; c=relaxed/simple;
	bh=kwvDubjA6kH2SE9IwlvlFxJtawBgsJJTASYdaOONNgA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BCyIgP1BWU3233uuzC/sUwsiMFVWnNsWGhU03RDSb+jux9JurpvhTwE+arzjFTkyhXsBzbL4wrk8B53DUaHgPzRRCLg8+wQ/cfRvquSzB84a73cNkqsudQR3LeLYCN9IcOWMzO83Jfd5gQUIpKGjG5qBxcT7aats4i0ibtlXCd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dkL5GlFQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dkL5GlFQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749559143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lcJJ1EAlVxXW8fg3TkpT3IG2yzH1IUN5iBry2fQN7Ik=;
	b=dkL5GlFQEBfTnBmPJJ9VKwauBV3clVs9Ia3N9wr/m6glrHwl9/m7MbhlZdVa2rfP40fZQF
	l5/mFBjAM3WYX4vgTo8woZ9uOM3Iml01dLR920uwYgQhjx3sKYlm4kVOL0k66GfcOiATrY
	SVpUnv22DOxveGKU6Jm4Cb/Dduh2w30=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-oZSSBSBSMQaDsgoD8SajtQ-1; Tue, 10 Jun 2025 08:39:02 -0400
X-MC-Unique: oZSSBSBSMQaDsgoD8SajtQ-1
X-Mimecast-MFC-AGG-ID: oZSSBSBSMQaDsgoD8SajtQ_1749559141
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f8fd1856so2228933f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 05:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749559140; x=1750163940;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lcJJ1EAlVxXW8fg3TkpT3IG2yzH1IUN5iBry2fQN7Ik=;
        b=PkPZ+trOZBuwPXWmaMqjKsvAZo0lD923VRe+j9qftcHHEN4hwctQkrQir2EBN7RXVr
         dyeMsSqFhxtNwZNI/0YHB5yxBNno0kwlWy/uODleTnw16m6kdwSjiZriHbCUQCFfeVAJ
         YMaCWg6QB8+JSnF9C3OEhgJzqJY8NDYKMY2ATOzbyWWFkjvRl4PKY18JsiwcZAlp2IZw
         ZNa0/fGkSt2Cp06Cvet2ivXsJwxTzKbAcPPIPHQ8mgFDuJppJ2n2qF4GcyRIGStZsOvX
         OOROxPRM19NXaHFlxA0SvQlOEZI7R4anBFyVAoXo7VuL8uiLJG2AzKrpHb8ao337nIfp
         3Hfw==
X-Gm-Message-State: AOJu0YwDOOj6GchCCmF7Iz4ZGfp0M92eWo57mTRG7Q+81A0LO2whDMKk
	nIey/oTWVzDpZP+JdF2N5fPnL2vbLNH1WtZ5Pwjov6HoATubyfGZ//1MVYqVDfYn1n3XLfy1YhC
	romUguSA+zW204EuXXXbxa8NYZpCQKUtz4h0OS1CuTTDELxTh56N0Ui098rA9VgaF7Q==
X-Gm-Gg: ASbGncvFR8K+BTxrD37Tj6BHGTpDnWO+x+ncb+qfcTiagpaSYdCBV/IynCuKARG/jKq
	3AZSSWEqsQF9qGf/JfMQD9hwIPfQsv9GmMS2Pjuj62dRspHQz7cAJGTdLCGjlQup1U5yleUbc6e
	0ri61NVbGedbERSZn0nNOFRiPE4G0NSHkAgD1X+MN15KhhB9k6WzFzAXLYPzpFV1qaoIP2/KSlw
	xQ9tDyIUeZE2hFmLYxcQh2i5bYiTVEUsDBhbWbAWFHGsGRZixAlN5EuFASnrlpUMat27k//bXJ5
	GjCTecZZlSrx46IuKRWZRIoiGxF5mrafSdVKONzjChDh3XkM9pI+eajYLkvV6mKaNcsNm80=
X-Received: by 2002:a05:6000:2389:b0:3a4:f786:4fa1 with SMTP id ffacd0b85a97d-3a5316841c4mr14337997f8f.2.1749559140666;
        Tue, 10 Jun 2025 05:39:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5FTEhqSFRlt1y1mpTyIqYcFsrFo2o2s+xhYDq5+1xXUONT5D6azW2BeFCdTM+2Ty2asNG3w==
X-Received: by 2002:a05:6000:2389:b0:3a4:f786:4fa1 with SMTP id ffacd0b85a97d-3a5316841c4mr14337967f8f.2.1749559140165;
        Tue, 10 Jun 2025 05:39:00 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4531fe85260sm10232795e9.0.2025.06.10.05.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 05:38:59 -0700 (PDT)
Date: Tue, 10 Jun 2025 14:38:58 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>
cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
    maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
    suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
Subject: Re: [PATCH] KVM: arm64: selftests: Close the GIC FD in
 arch_timer_edge_cases
In-Reply-To: <20250608095402.1131-1-yuzenghui@huawei.com>
Message-ID: <e13b52c9-359e-ae64-ff15-c13acd6111ef@redhat.com>
References: <20250608095402.1131-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0RtB9VwK6ExMpiYK2odZFzibjiK_RDw6h9w4GotYJXU_1749559141
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Sun, 8 Jun 2025, Zenghui Yu wrote:

> Close the GIC FD to free the reference it holds to the VM so that we can
> correctly clean up the VM. This also gets rid of the
>
> 	"KVM: debugfs: duplicate directory 395722-4"
>
> warning when running arch_timer_edge_cases.
>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

