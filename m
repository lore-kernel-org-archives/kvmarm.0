Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613D931CA4A
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 05:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765778107; cv=none; b=OT3KuBZaxI6SgUG8YvhmWBqzxVw6z2zBsB5rWTpXtar09gaJU8if+eyNii7cCuQxYp7S/0oqeqqVwCFuy1Z9pIHfO2dZG/ebm0OfA6MdTl44QK014viPjiEp+atngL5MFrrJeX71dFtWQ3W3mgIx8ofv/53gMeb4zB8GE1ys6Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765778107; c=relaxed/simple;
	bh=l+eRO9cUwdOLQGXpGCxkU0xWlzqvEtT06h1zGGZRF8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ugx6Ks9tfJEUKGlXSTYrqjdTJYIyx2retI9NSMdPIMg1HETktvZ0o1/hGNCv8CbPrvZAX6LsMQqpQnDVKruWFDQlvTiQCaQCy21GKcitpvJtPbzhyX3qFGpaMSn4kQI/B8b3p4yNSMj5T3dCo79FTl66ycRviLbSStGjsDh/wVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B9fkVznx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B9fkVznx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765778103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d05K16DKQiEd3StceTnrw6JfNIHdbpDM1WqXFgxTmJw=;
	b=B9fkVznxLpPqsDz5fCQzv3M4RsXU88R+F1wZRcsk6GhrBE1Hb2cqdU3v0D/i041gmSo5A0
	yqAgiAKTR7hO3FWD1EnH0pUuGaoJb2pBzqwsS5R1xxQtjZCs6cI7FvHd1yHrXmhGIjpW5A
	+z+hr1O0pDqCc4pUfaGsRa/R7Z8+bGQ=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-8zKBKR9mPdS3eN5zlWCS5g-1; Mon, 15 Dec 2025 00:54:59 -0500
X-MC-Unique: 8zKBKR9mPdS3eN5zlWCS5g-1
X-Mimecast-MFC-AGG-ID: 8zKBKR9mPdS3eN5zlWCS5g_1765778099
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7b82c2c2ca2so4769638b3a.1
        for <kvmarm@lists.linux.dev>; Sun, 14 Dec 2025 21:54:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765778099; x=1766382899;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d05K16DKQiEd3StceTnrw6JfNIHdbpDM1WqXFgxTmJw=;
        b=TlAx0uRhBNaPIk9z5trODlsNY363Jdy/5/i4k2R7bD6Aj9fKgxwVirft9GoAHKJdnU
         ik8r6r+OVEhzCu7MskLBbuOwoPgZgDpDIhT8r4wksr4BXqyrlSKzQWua3eo790IBb/2a
         0elvRwK0y020Y/xEZ286XXeCipRAf8YkkDJSgupoSDYQybJF/fd2dO0K7JV9xFGpY4wi
         hWI+fcchSXNztgo+O6Ghn2CwyL5/BpAB2gNF7ukYR+nNC5775Ej/jI0lAPRWAxSYxYwy
         eJdDoqerfOKcbvDPSeF/IvMXQiziKsEKFykrpn8g9RIJoxtN1p1vrFqx5yB5+s9ZCoNZ
         32Qw==
X-Forwarded-Encrypted: i=1; AJvYcCX/O/o/nevuozAtlxqPx337AlXORAdS5bxiaTuW3JmGyhO9uRqeLiEbQyaiCE6JdOpImzztebs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTvW3GF0xe7udulX+46mTYgMnovp8ezepWuin8U1xJfm9sIUvf
	GgE6fOjrxe9Brle5+Ot+jABS7Uz9LmMM+ZHbsuIbQxzI+q8DiuUOKkpoiEe09WVk9yvnoGxk3WX
	ZKRoet1s1o1Dbj4Wjx88aE3pfrq6kfogJGqKNY2KM8V/TiVy+SepMnZ4qzw==
X-Gm-Gg: AY/fxX4Y5gt+n3G9T5jWse/JtY4v9EfFqmTyiYewlK2VotcqTzJeqGK2QzLLbjGjkU+
	WfO+gPzJKB3GwiErdX1FAHVNl4xF6ZQ7cN2GmqtBYDBNcUbydwl3WqwJ2UxyY4mKaxzEoV7VQO3
	0USew7UMcI+4XwsyP+9vEIZY1VlEw742Np59o55jzYzhPXberG40my6YhIr/a09cG4bnPexJzdf
	i4hh0rB9msQKm8233F33qFY1wZCV3qxmiCBuPm0NFnjZim6tgcLy9FcZCgE4jtz5f6AJ8rIhfY1
	KOrMQKzn/wXC1FGG0GoHrxHt8sz6ASDugwUE9Bpc6cSxEsuohfytEkajCdVbUV3kL4Wulnelp6x
	Iogj7TDP4xwjyWrCFbBAt8R84z5hiRDhm+Z/tNnplJ8urX/mSfA==
X-Received: by 2002:a05:6a00:4909:b0:7f7:1fcf:689c with SMTP id d2e1a72fcca58-7f71fcf69d3mr4683897b3a.9.1765778098691;
        Sun, 14 Dec 2025 21:54:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE966N7Oe3FYB9Ygha15iCWE5PrCNEQSbD/T0JrM44KTdQUsyD3mTxS9KuJWZ4khGMwT3U8QA==
X-Received: by 2002:a05:6a00:4909:b0:7f7:1fcf:689c with SMTP id d2e1a72fcca58-7f71fcf69d3mr4683888b3a.9.1765778098358;
        Sun, 14 Dec 2025 21:54:58 -0800 (PST)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c5093a4bsm11405855b3a.50.2025.12.14.21.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Dec 2025 21:54:57 -0800 (PST)
Message-ID: <c41a18ed-f282-449c-949c-17ced2e92790@redhat.com>
Date: Mon, 15 Dec 2025 15:54:52 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: sea_to_user sefltest failure
To: Sebastian Ott <sebott@redhat.com>, Jiaqi Yan <jiaqiyan@google.com>
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.linux.dev,
 linux-kselftest@vger.kernel.org
References: <1478ac09-8134-5551-13b6-c7be096262af@redhat.com>
 <CACw3F52i_Yr+8Gd1=H=EMi7NnVJ8WCgMkaG1dSe8FD7PvOsW8w@mail.gmail.com>
 <c44b75bd-bf54-0aab-78a2-89f448cf126c@redhat.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <c44b75bd-bf54-0aab-78a2-89f448cf126c@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lnUYHgnbaWs6GHOvioM3rtNIG0QGmtrMqV3GX3yB11Y_1765778099
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/25 4:11 AM, Sebastian Ott wrote:
> On Thu, 11 Dec 2025, Jiaqi Yan wrote:
>> CONFIGs seem alright to me. Do you boot kernel with cmdline options like "default_hugepagesz=1G hugepagesz=1G hugepages=64", or dynamically set up
>> huge pages via "echo 64 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages"?
> 
> Neither of these. When I do the test is skipped:
> # echo 64 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

The backing memory is tied to 1GB hugetlb pages which are available on 4KB
and 16KB host, but not on 64KB host. So I guess 512MB hugetlb pages shall
be used on 64KB host?

> # ./arm64/sea_to_user
> Random seed: 0x6b8b4567
> # Mapped 0x40000 pages: gva=0x80000000 to gpa=0xff80000000
> # Before EINJect: data=0xbaadcafe
> # EINJ_GVA=0x81234bad, einj_gpa=0xff81234bad, einj_hva=0xffff41234bad, einj_hpa=0x80241234bad
> ok 1 # SKIP EINJ module probably not loaded?sh: line 1: /sys/kernel/debug/apei/einj/error_type: No such file or directory
> Bail out! Failed to write EINJ entry: No such file or directory (2)
> # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> # Planned tests != run tests (0 != 1)
> # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
> 

On one of my machines where RAS feature used to work, the test case passed
on 4KB host.

host$ cat /proc/1/smaps | grep KernelPageSize | head -n 1
KernelPageSize:        4 kB
host$ modprobe einj
host$ echo 4 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

host$ ./sea_to_user
Random seed: 0x6b8b4567
# Mapped 0x40000 pages: gva=0x80000000 to gpa=0xff80000000
# Before EINJect: data=0xbaadcafe
# EINJ_GVA=0x81234bad, einj_gpa=0xff81234bad, einj_hva=0xffff41234bad, einj_hpa=0x400081234bad
# echo 0x10 > /sys/kernel/debug/apei/einj/error_type - done
# echo 0x2 > /sys/kernel/debug/apei/einj/flags - done
# echo 0x400081234bad > /sys/kernel/debug/apei/einj/param1 - done
# echo 0xffffffffffffffff > /sys/kernel/debug/apei/einj/param2 - done
# echo 0x1 > /sys/kernel/debug/apei/einj/notrigger - done
# echo 0x1 > /sys/kernel/debug/apei/einj/error_inject - done
# Memory UER EINJected
# SIGBUS (7) received, dumping siginfo...
# si_signo=7, si_errno=0, si_code=4, si_addr=0xffff41234000
ok 1 # SKIP SEA is claimed by host APEI

Thanks,
Gavin

