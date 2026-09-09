Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C083EAC76
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 10:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788951176; cv=none; b=Oadu/lFX534sB71edfaWsXyOXi0/4SOEc+msR+EvelA8pg3VIXJMrgYgYiupS4Ul+UYba1BiAkxwcHyexXSAU6VUvnQkGz3onp27t8VDZK59O15tywRmmZwTJYxPXKwqNQqayS5jy6pLpLTF9ckrUc4sMxbm6opqjCcMjDXDD/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788951176; c=relaxed/simple;
	bh=XjDRR5JQG/3VoeAbLuJHHZjhK8tUn5hqdVxddhdHGXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nTdDSXVaNCQwADRH2bFKUZbWrxi8+MIHRr3LAisE+l6/blVdVW98DScD0O9j6I3I++PjbCH6ejZRCNBV1SsNQbh8N/ob9qJYOKgcf9fxKwcJ1jhvb8hmbN7vERCaUyHXwXPf6xVtb41ryavuwXRxZlIIgciNGBmZC2LIa9BYJDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HA6pwPfm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HA6pwPfm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788951170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kl+bPaD4PaQFBmaUCjR6vm4GXg7ogX+Oac8DkWGxKR8=;
	b=HA6pwPfmatnQhEV9qdH/jAspFrOozIrNYjDEbGgfNaAVAccDhvTPQnpB8VIVOKArtPTMjQ
	iVbXNkZB5+dGz9QsUH0Q/YO71HyCghpmJUKhuK6yk0nYv+F+d62kWvalmxRhsZj0iSE3Ni
	oByr5HslgOlsNMQh/MPZQ6xKYQoEfkQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-b6xAA93KPLKWtsggkRHoJg-1; Wed, 09 Sep 2026 06:52:48 -0400
X-MC-Unique: b6xAA93KPLKWtsggkRHoJg-1
X-Mimecast-MFC-AGG-ID: b6xAA93KPLKWtsggkRHoJg_1788951168
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2db3734d06dso80590165ad.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 03:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788951167; x=1789555967;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jlII6PmLS6Fy2IEhFtMVBBXGY0oZneRlW8U4Qxok/SY=;
        b=M/gdAXByHpdLF6lPyZGL0mlGLPbL9KU/jr6ZEymNiyesprNXMaux3TpxGEhTpYp4zU
         j5alsyF7JDElUWBKDCjuTZPJmwSSivdOyyV64rign7eynuP7rK1lmfjNhKcZD4CJonXN
         H5aoaehgHsZlNjob7414NjzJRSQnUn5cpXcvepaQ//qNpqgB5SqW9/KcVgOFTvnB8X0g
         xbqjLn1efpyXsVs/2g3XF92uNuhTsNc/zF6hDSJm7VPAPfqNXvcUGJS6sfF/TtChHRJF
         MVMmtj9ozORojO0acrEUaSDMBieS4izG6R3cPqmI9CIn7h1sWZs4NWM3LmUC1H2Jl6b0
         rcdg==
X-Forwarded-Encrypted: i=1; AKwUvBxtTfkL7mfdWpOX8lam1kfNYv/QvFJ0e+Ln05BPIFtlE/8Rnl8sBoTras/lFDevf7+sDh86SXw=@lists.linux.dev
X-Gm-Message-State: AFuF++meeYkRjvrBAJpJSLIbZMew6aXXXp1Z/aYjUKjg21RSTSoMXkhD
	OPdS7j6mIp1j+JXUJsO7P+x16WJ5PM0PByQ0RucA9NgZAMB9fEmNGTkFL3DBOeL4uOmyKnIMjUI
	iza9kTTA3apkcOqNT3+DM8GmnzKRZbdaqMd39L2F88ZFTZrdjNd/QXAxp1A==
X-Gm-Gg: AYBFou1IrOAdjRowszBYJLnjWpd/91FjwAJNClqYjJyBQ9VJgw85U25r91Wm2e7hiDz
	jP/E3GxUlzGnxpHsHr6Eryey75Z531GNkisi6AuFzvcu+gxDTWx4iE82T6TjRok0Ody+OlNKUV9
	VIHpegLCrjTaHETtoBizWXyZq5gbvkR1jtM0b9A72hOzHqfIZYDJPPv7znhPdnuxh+JSumLbnyi
	3yoT2fKhRWjA0TYOyDeEo63tLd+wk3QwmFNObQ/ybWE2DSWEHXQwKzMAmPuUtHJClz1a/R1LVyr
	t11CupGnZ8wgSM2UB2uTn+mk6PMy6YdRobv91qe5Fvfnqs749EQ4p/70x7L056ElDhBlHrsffz8
	XAOf61gDGxlQI+yo0cR3WbMELlRwMfYONTvvjdnoGIA==
X-Received: by 2002:a17:90b:5844:b0:38f:5869:387b with SMTP id 98e67ed59e1d1-39b26101c20mr51714311a91.9.1788951167417;
        Wed, 09 Sep 2026 03:52:47 -0700 (PDT)
X-Received: by 2002:a17:90b:5844:b0:38f:5869:387b with SMTP id 98e67ed59e1d1-39b26101c20mr51714221a91.9.1788951166708;
        Wed, 09 Sep 2026 03:52:46 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b260fe843sm31417683a91.10.2026.09.09.03.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 03:52:45 -0700 (PDT)
Message-ID: <9086ca6a-5dce-493f-ac76-487dedc60758@redhat.com>
Date: Wed, 9 Sep 2026 20:52:33 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 0/7] firmware: arm_rmm: Add RMM v2.0 base RMI support
To: Kohei Enju <enju.kohei@fujitsu.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 tabba@google.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
 alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
 lpieralisi@kernel.org
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <ap-C6NLnxuWWTMzi@FCCLS0092175.localdomain>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <ap-C6NLnxuWWTMzi@FCCLS0092175.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zBXTCwc8qbRs7LQEqN3PPdYIdqdwVGrW7ntVLw2OKqQ_1788951168
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="------------ARHmqz6kmyRmg021RcSq0ymY"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------ARHmqz6kmyRmg021RcSq0ymY
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kohei,

On 9/8/26 2:09 PM, Kohei Enju wrote:

[...]

>>
>> [1] RMM spec : https://support.arm.com/documentation/den0137/2-0bet3/
>> [2] This series: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/fw_rmm/v17
>> [3] KVM CCA v17 integration branch: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/kvm-integration/v17
>> [4] Gmem inplace conversion https://github.com/googleprodkernel/linux-cc/tree/guest_memfd-inplace-conversion-v12
>> [5] TF-RMM https://git.trustedfirmware.org/TF-RMM/tf-rmm.git main (commit: 134266ae)
> 
> I understand that QEMU-virt is not intended to model a realistic
> production platform and that QEMU-SBSA is generally preferred. However,
> I sometimes use QEMU-virt to test functionality quickly because it runs
> slightly faster than QEMU-SBSA.
> 
> I tested this series with QEMU-virt and found that RMM initialization
> failed during boot:
> 
>    [...]
>    INFO:    BL31: Initializing RMM
>    INFO:    RMM init start.
>    ERROR:   RMM init failed: -8
>    WARNING: BL31: RMM initialization failed
> 
I also ran into same issue and attached TF-A patch leads to a successful
RMM initialization, please have a try to see if it can resolve your issue.


Thanks,
Gavin

--------------ARHmqz6kmyRmg021RcSq0ymY
Content-Type: text/x-patch; charset=UTF-8; name="tf-a.patch"
Content-Disposition: attachment; filename="tf-a.patch"
Content-Transfer-Encoding: base64

RnJvbSBjMjJkZGM0MzY4NjUwNTUwODQ1Zjg2MmZjMDdjYjM1Yjk5OGZiYjIzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHYXZpbiBTaGFuIDxnc2hhbkByZWRoYXQuY29tPgpEYXRlOiBX
ZWQsIDkgU2VwIDIwMjYgMTk6NTg6MzcgKzEwMDAKU3ViamVjdDogW1BBVENIXSBwbGF0L3FlbXU6
IGFkZCBwbGF0X3JtbWRfcmVzZXJ2ZV9tZW1vcnkoKSBmb3IgVklSVCBwbGF0Zm9ybQpNSU1FLVZl
cnNpb246IDEuMApDb250ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgKQ29udGVu
dC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKU2lnbmVkLW9mZi1ieTogR2F2aW4gU2hhbiA8Z3No
YW5AcmVkaGF0LmNvbT4KLS0tCiBwbGF0L3FlbXUvcWVtdS9pbmNsdWRlL3BsYXRmb3JtX2RlZi5o
ICB8ICAzICsrKwogcGxhdC9xZW11L3FlbXUvcGxhdF9ybW1fbWVtX2NhcnZlb3V0LmMgfCAyOCAr
KysrKysrKysrKysrKysrKysrKysrKysrKwogcGxhdC9xZW11L3FlbXUvcGxhdGZvcm0ubWsgICAg
ICAgICAgICAgfCAgNCArKysrCiAzIGZpbGVzIGNoYW5nZWQsIDM1IGluc2VydGlvbnMoKykKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBwbGF0L3FlbXUvcWVtdS9wbGF0X3JtbV9tZW1fY2FydmVvdXQuYwoK
ZGlmZiAtLWdpdCBhL3BsYXQvcWVtdS9xZW11L2luY2x1ZGUvcGxhdGZvcm1fZGVmLmggYi9wbGF0
L3FlbXUvcWVtdS9pbmNsdWRlL3BsYXRmb3JtX2RlZi5oCmluZGV4IDA2MDE4ZTdiMi4uYzNlZDk4
NmNmIDEwMDY0NAotLS0gYS9wbGF0L3FlbXUvcWVtdS9pbmNsdWRlL3BsYXRmb3JtX2RlZi5oCisr
KyBiL3BsYXQvcWVtdS9xZW11L2luY2x1ZGUvcGxhdGZvcm1fZGVmLmgKQEAgLTM2OCw2ICszNjgs
OSBAQCBDQVNTRVJUKChQTEFUX1FFTVVfTDBfR1BUX0JBU0UgJiAoUExBVF9RRU1VX0wwX0dQVF9T
SVpFIC0gMSkpID09IDAsCiAjZGVmaW5lIFJNTV9TSEFSRURfQkFTRQkJCShSTU1fTElNSVQpCiAj
ZGVmaW5lIFJNTV9TSEFSRURfU0laRQkJCVBMQVRfUUVNVV9STU1fU0hBUkVEX1NJWkUKIAorI2Rl
ZmluZSBQTEFUX0FSTV9STU1fUEFZTE9BRF9TSVpFCVVMKDB4NjAwMDAwKSAgICAvKiAyICogM01C
ICovCisjZGVmaW5lIFJNTV9QQVlMT0FEX0xJTUlUCQkoUk1NX0JBU0UgKyBQTEFUX0FSTV9STU1f
UEFZTE9BRF9TSVpFKQorCiAvKgogICogV2UgYWRkIHRoZSBSTU1fU0hBUkVEIHNpemUgdG8gUk1N
IG1hcHBpbmcgdG8gbWFwIHRoZSByZWdpb24gYXMgYSBibG9jay4KICAqIEVsc2Ugd2UgZW5kIHVw
IHJlcXVpcmluZyBtb3JlIHBhZ2V0YWJsZXMgaW4gQkwyIGZvciBST01MSUIgYnVpbGQuCmRpZmYg
LS1naXQgYS9wbGF0L3FlbXUvcWVtdS9wbGF0X3JtbV9tZW1fY2FydmVvdXQuYyBiL3BsYXQvcWVt
dS9xZW11L3BsYXRfcm1tX21lbV9jYXJ2ZW91dC5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4
IDAwMDAwMDAwMC4uYzY4Y2EyNDNkCi0tLSAvZGV2L251bGwKKysrIGIvcGxhdC9xZW11L3FlbXUv
cGxhdF9ybW1fbWVtX2NhcnZlb3V0LmMKQEAgLTAsMCArMSwyOCBAQAorLyoKKyAqIENvcHlyaWdo
dCAoYykgMjAyNiwgQXJtIExpbWl0ZWQgYW5kIENvbnRyaWJ1dG9ycy4gQWxsIHJpZ2h0cyByZXNl
cnZlZC4KKyAqCisgKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogQlNELTMtQ2xhdXNlCisgKi8K
KworI2luY2x1ZGUgPGxpYi9zcGlubG9jay5oPgorI2luY2x1ZGUgPHBsYXQvY29tbW9uL3BsYXRm
b3JtLmg+CisKK3N0YXRpYyBzcGlubG9ja190IG1lbV9yZXNlcnZlX2xvY2s7CitzdGF0aWMgdWlu
dHB0cl90IHRvcF9tZW0gPSBSTU1fTElNSVQ7CisKK3VpbnRwdHJfdCBwbGF0X3JtbWRfcmVzZXJ2
ZV9tZW1vcnkoc2l6ZV90IHNpemUsIHVuc2lnbmVkIGxvbmcgYWxpZ25tZW50KQoreworCXVpbnQ2
NF90IGFsaWduX21hc2sgPSBhbGlnbm1lbnQgLSAxOworCXVpbnRwdHJfdCBhZGRyOworCisJc3Bp
bl9sb2NrKCZtZW1fcmVzZXJ2ZV9sb2NrKTsKKwlhZGRyID0gKHRvcF9tZW0gLSBzaXplKSAmIH5h
bGlnbl9tYXNrOworCWlmIChhZGRyID49IFJNTV9QQVlMT0FEX0xJTUlUKSB7CisJCXRvcF9tZW0g
PSBhZGRyOworCX0gZWxzZSB7CisJCWFkZHIgPSAwOworCX0KKwlzcGluX3VubG9jaygmbWVtX3Jl
c2VydmVfbG9jayk7CisKKwlyZXR1cm4gYWRkcjsKK30KZGlmZiAtLWdpdCBhL3BsYXQvcWVtdS9x
ZW11L3BsYXRmb3JtLm1rIGIvcGxhdC9xZW11L3FlbXUvcGxhdGZvcm0ubWsKaW5kZXggMmUxMmY2
YmNhLi42NTVjYzY4M2EgMTAwNjQ0Ci0tLSBhL3BsYXQvcWVtdS9xZW11L3BsYXRmb3JtLm1rCisr
KyBiL3BsYXQvcWVtdS9xZW11L3BsYXRmb3JtLm1rCkBAIC0xNzUsNiArMTc1LDEwIEBAIEJMMzFf
U09VUkNFUwkJKz0JcGxhdC9jb21tb24vcGxhdF9zcG1kX21hbmlmZXN0LmMJXAogCQkJCSR7RkRU
X1dSQVBQRVJTX1NPVVJDRVN9CiBlbmRpZgogCitpZmVxICgke0VOQUJMRV9STU19LDEpCitCTDMx
X1NPVVJDRVMJCSs9CSR7UExBVF9RRU1VX1BBVEh9L3BsYXRfcm1tX21lbV9jYXJ2ZW91dC5jCitl
bmRpZgorCiBpZm5lcSAoJHtFTkFCTEVfRkVBVF9STkdfVFJBUH0sMCkKIEJMMzFfU09VUkNFUwkJ
Kz0JcGxhdC9xZW11L3FlbXUvcWVtdV9zeW5jX3RyYXBzLmMKIGVuZGlmCi0tIAoyLjU1LjAKCg==

--------------ARHmqz6kmyRmg021RcSq0ymY--

