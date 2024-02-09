Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75197EF17
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 17:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707501446; cv=none; b=iP7jeP4tLjslmy4vD+ZhNGghdZa3q0bktm5l6NsWenTcj5L+GCB1EL2UfLX9fHbSlN2AnWNuI0EB2iGZwfe7whkl21q0NuICfqOm0EUFKfOxc8KRCjc41db0V+uyyFrKVbF2xzyriw4Ty/xuLu9lkxIxVrcxq9D38BZO12Tug8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707501446; c=relaxed/simple;
	bh=Ullq2irJQ2xO6WZijRd1IqfiDrXBUIKp6+qZkaAWTd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZdBmMagx/xv99BCvxPWYDer54OFsPybPFmqqgHi0H+pfplp/hTYn4xI3hgelaX/Mbwe5AoMscwhBNUPWlnQutDgNqz03hw/CDGSibDO6u7oh0rhP6Wk3ICzXZz2jcMv2qmqa/96j+9BTS47XklsxNzKFyDZ5Phvae7pBS+45yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PPC5XmDG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PPC5XmDG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707501442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2kgITGNgRH4Wqk6mUUFnib2/8oqDp6rW8fOt5+7CaGI=;
	b=PPC5XmDGBvqKXPIj5WdfBw6jE58eM6EhdzRfuAfs2GNOcc2H+NIbz0LNykEfDeSpburPTU
	iNhNmuagYrekW4yMsMxQqU/12ZRufRT1YjTeLcPp6jgincqqbAwehlUExuf8g5OFXNBy3j
	tEDL9za3/it0t2koGaLoQWj8rwXX43g=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-96MxkYTrN2Gfw_WYPQxyRw-1; Fri, 09 Feb 2024 12:57:21 -0500
X-MC-Unique: 96MxkYTrN2Gfw_WYPQxyRw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-781d8e14fd8so148831885a.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Feb 2024 09:57:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707501440; x=1708106240;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2kgITGNgRH4Wqk6mUUFnib2/8oqDp6rW8fOt5+7CaGI=;
        b=p26oQlNxE7rOLUOeYDCNrd9odHLYF4dxgZwXAb2zrndq6k5nK16AkSyNR/G9dg9C28
         6myIOU/7KC3w4imAa7Bo7dXueQwMY6o2TD10J6WYlfZKVXDnP/wZHzauuKRkPe7bp2Ad
         jMxmchgmv+e6Ey0gqQlnKgE6y7pZOrKepMaaPTV6O/ER4QyxWsKYJ1J2N4v4Hkxul/vR
         OpWRKiX2qS44cFVbx8mNWcyT+fK3NNF2KEgsntJEFj64x0ypEsXJooH+onyGuCHzOEyU
         fUk2d+UyS7Gws1cEu2ry4Yy/Ok4gNoVPQ/YcnlE3EivPizS7hqQeepiy53CNCvfvpp5A
         TdOg==
X-Gm-Message-State: AOJu0YxiA8Q0FtKuu+9DTIEjFkwYo/DnHMgxw0L8u9oBGmEV3eLnCgat
	wwnW8tSP+SOsnO2r1xdSxqgpWPFxDICVaT7+2QMP7jQ7dfhkATuS5METfX05pn6Mt0T0OsB0Vmu
	tzy3OasiZpS1aqgZuhsn6UZSimo3fRxGbXNv2uH7gGVuocnllEsjohw==
X-Received: by 2002:a05:620a:199a:b0:783:cb5a:ec3b with SMTP id bm26-20020a05620a199a00b00783cb5aec3bmr2878167qkb.71.1707501440697;
        Fri, 09 Feb 2024 09:57:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFh9eBa+uL0TgU8I7s2UC/0d5VeQVwvoUVp9Qb/f8h1ezUPmyU5PofF8iaO+q5Htkiy1Je+JQ==
X-Received: by 2002:a05:620a:199a:b0:783:cb5a:ec3b with SMTP id bm26-20020a05620a199a00b00783cb5aec3bmr2878147qkb.71.1707501440460;
        Fri, 09 Feb 2024 09:57:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXxdog3KtAVjA17ihb7yJMbtJys8LsF81l51sg4R8zhMr2ceg2lq62vOmj3gdhH39XD6aOFg9/L2Tk7nAT44EypfeNloh5Yb7v4MNhzbRx4awkuF9OcLqiBSxinoNtZLQBjd50L0P1ROKqAWPwz+/ohXd3W9z1cF830kNeU2FJXwo8LBlzxZMk/AsGOGTG7TvpjQJSar+4xvsPmATSrwMdekkSzwlnVvUqAtnC0xfnJVhcy2Hmwxh4+pZu2R3EXYzUgXla5jBmGgT1V2oyqG0bckI9VnJeIVGRD4sIsai7qCEtnLQHCyTtxBJWqJ+wj5SuLs48NSjgUR9iw/Pswh+ZmZiJOGnuxamkYGHPerL947oleU1N+nqSQmvm2Hpcrd3vXFVykzbExpeInqc9aC4rz6ohJv5jdthDnIk9YkLNxuQjJmRdFIKgVoKuyURm1BI+3Vnx2cIYKcvMdK74s3GZinvKMrYLpZcLDpnQGHSWPH4yUTeqivOQ3O1cRuvuqj2A4zqr0mjnP5HtxAM2hrc/gYj4Z
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id f6-20020a05620a12e600b0078552b5e161sm896441qkl.78.2024.02.09.09.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 09:57:20 -0800 (PST)
Message-ID: <54232155-ef97-4911-b1c7-acc7ee06a676@redhat.com>
Date: Fri, 9 Feb 2024 18:57:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 4/8] migration: Support multiple
 migrations
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org
References: <20240209091134.600228-1-npiggin@gmail.com>
 <20240209091134.600228-5-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 xsFNBFH7eUwBEACzyOXKU+5Pcs6wNpKzrlJwzRl3VGZt95VCdb+FgoU9g11m7FWcOafrVRwU
 yYkTm9+7zBUc0sW5AuPGR/dp3pSLX/yFWsA/UB4nJsHqgDvDU7BImSeiTrnpMOTXb7Arw2a2
 4CflIyFqjCpfDM4MuTmzTjXq4Uov1giGE9X6viNo1pxyEpd7PanlKNnf4PqEQp06X4IgUacW
 tSGj6Gcns1bCuHV8OPWLkf4hkRnu8hdL6i60Yxz4E6TqlrpxsfYwLXgEeswPHOA6Mn4Cso9O
 0lewVYfFfsmokfAVMKWzOl1Sr0KGI5T9CpmRfAiSHpthhHWnECcJFwl72NTi6kUcUzG4se81
 O6n9d/kTj7pzTmBdfwuOZ0YUSqcqs0W+l1NcASSYZQaDoD3/SLk+nqVeCBB4OnYOGhgmIHNW
 0CwMRO/GK+20alxzk//V9GmIM2ACElbfF8+Uug3pqiHkVnKqM7W9/S1NH2qmxB6zMiJUHlTH
 gnVeZX0dgH27mzstcF786uPcdEqS0KJuxh2kk5IvUSL3Qn3ZgmgdxBMyCPciD/1cb7/Ahazr
 3ThHQXSHXkH/aDXdfLsKVuwDzHLVSkdSnZdt5HHh75/NFHxwaTlydgfHmFFwodK8y/TjyiGZ
 zg2Kje38xnz8zKn9iesFBCcONXS7txENTzX0z80WKBhK+XSFJwARAQABzR5UaG9tYXMgSHV0
 aCA8dGh1dGhAcmVkaGF0LmNvbT7CwXgEEwECACIFAlVgX6oCGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAAoJEC7Z13T+cC21EbIP/ii9cvT2HHGbFRl8HqGT6+7Wkb+XLMqJBMAIGiQK
 QIP3xk1HPTsLfVG0ao4hy/oYkGNOP8+ubLnZen6Yq3zAFiMhQ44lvgigDYJo3Ve59gfe99KX
 EbtB+X95ODARkq0McR6OAsPNJ7gpEUzfkQUUJTXRDQXfG/FX303Gvk+YU0spm2tsIKPl6AmV
 1CegDljzjycyfJbk418MQmMu2T82kjrkEofUO2a24ed3VGC0/Uz//XCR2ZTo+vBoBUQl41BD
 eFFtoCSrzo3yPFS+w5fkH9NT8ChdpSlbNS32NhYQhJtr9zjWyFRf0Zk+T/1P7ECn6gTEkp5k
 ofFIA4MFBc/fXbaDRtBmPB0N9pqTFApIUI4vuFPPO0JDrII9dLwZ6lO9EKiwuVlvr1wwzsgq
 zJTPBU3qHaUO4d/8G+gD7AL/6T4zi8Jo/GmjBsnYaTzbm94lf0CjXjsOX3seMhaE6WAZOQQG
 tZHAO1kAPWpaxne+wtgMKthyPLNwelLf+xzGvrIKvLX6QuLoWMnWldu22z2ICVnLQChlR9d6
 WW8QFEpo/FK7omuS8KvvopFcOOdlbFMM8Y/8vBgVMSsK6fsYUhruny/PahprPbYGiNIhKqz7
 UvgyZVl4pBFjTaz/SbimTk210vIlkDyy1WuS8Zsn0htv4+jQPgo9rqFE4mipJjy/iboDzsFN
 BFH7eUwBEAC2nzfUeeI8dv0C4qrfCPze6NkryUflEut9WwHhfXCLjtvCjnoGqFelH/PE9NF4
 4VPSCdvD1SSmFVzu6T9qWdcwMSaC+e7G/z0/AhBfqTeosAF5XvKQlAb9ZPkdDr7YN0a1XDfa
 +NgA+JZB4ROyBZFFAwNHT+HCnyzy0v9Sh3BgJJwfpXHH2l3LfncvV8rgFv0bvdr70U+On2XH
 5bApOyW1WpIG5KPJlDdzcQTyptOJ1dnEHfwnABEfzI3dNf63rlxsGouX/NFRRRNqkdClQR3K
 gCwciaXfZ7ir7fF0u1N2UuLsWA8Ei1JrNypk+MRxhbvdQC4tyZCZ8mVDk+QOK6pyK2f4rMf/
 WmqxNTtAVmNuZIwnJdjRMMSs4W4w6N/bRvpqtykSqx7VXcgqtv6eqoDZrNuhGbekQA0sAnCJ
 VPArerAZGArm63o39me/bRUQeQVSxEBmg66yshF9HkcUPGVeC4B0TPwz+HFcVhheo6hoJjLq
 knFOPLRj+0h+ZL+D0GenyqD3CyuyeTT5dGcNU9qT74bdSr20k/CklvI7S9yoQje8BeQAHtdV
 cvO8XCLrpGuw9SgOS7OP5oI26a0548M4KldAY+kqX6XVphEw3/6U1KTf7WxW5zYLTtadjISB
 X9xsRWSU+Yqs3C7oN5TIPSoj9tXMoxZkCIHWvnqGwZ7JhwARAQABwsFfBBgBAgAJBQJR+3lM
 AhsMAAoJEC7Z13T+cC21hPAQAIsBL9MdGpdEpvXs9CYrBkd6tS9mbaSWj6XBDfA1AEdQkBOn
 ZH1Qt7HJesk+qNSnLv6+jP4VwqK5AFMrKJ6IjE7jqgzGxtcZnvSjeDGPF1h2CKZQPpTw890k
 fy18AvgFHkVk2Oylyexw3aOBsXg6ukN44vIFqPoc+YSU0+0QIdYJp/XFsgWxnFIMYwDpxSHS
 5fdDxUjsk3UBHZx+IhFjs2siVZi5wnHIqM7eK9abr2cK2weInTBwXwqVWjsXZ4tq5+jQrwDK
 cvxIcwXdUTLGxc4/Z/VRH1PZSvfQxdxMGmNTGaXVNfdFZjm4fz0mz+OUi6AHC4CZpwnsliGV
 ODqwX8Y1zic9viSTbKS01ZNp175POyWViUk9qisPZB7ypfSIVSEULrL347qY/hm9ahhqmn17
 Ng255syASv3ehvX7iwWDfzXbA0/TVaqwa1YIkec+/8miicV0zMP9siRcYQkyTqSzaTFBBmqD
 oiT+z+/E59qj/EKfyce3sbC9XLjXv3mHMrq1tKX4G7IJGnS989E/fg6crv6NHae9Ckm7+lSs
 IQu4bBP2GxiRQ+NV3iV/KU3ebMRzqIC//DCOxzQNFNJAKldPe/bKZMCxEqtVoRkuJtNdp/5a
 yXFZ6TfE1hGKrDBYAm4vrnZ4CXFSBDllL59cFFOJCkn4Xboj/aVxxJxF30bn
In-Reply-To: <20240209091134.600228-5-npiggin@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 10.11, Nicholas Piggin wrote:
> Support multiple migrations by flipping dest file/socket variables to
> source after the migration is complete, ready to start again. A new
> destination is created if the test outputs the migrate line again.
> Test cases may now switch to calling migrate() one or more times.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/migrate.c         |  8 ++--
>   lib/migrate.h         |  1 +
>   scripts/arch-run.bash | 86 ++++++++++++++++++++++++++++++++++++-------
>   3 files changed, 77 insertions(+), 18 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


