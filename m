Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01D37B
	for <kvmarm@lists.linux.dev>; Tue, 25 Apr 2023 00:37:14 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5191796a483so3978878a12.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 17:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682383034; x=1684975034;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHR3/LN2j1zsFd+vHZpilKnpPMmVBsE4NTdgmjY6waM=;
        b=mbsdt0OhKWkJAFwZLAa0Hxblc5IB4blY+u4h2FFObzYzmEJ86IEablzUUQr4q+SMbF
         DasXtsz853hCizMWFholuum6/8w4kDfj8Oc+DcAmcnqUAfPTUtaa4RogX81Acy27opUN
         F4v8K1nhuWy4Ad6xYFk8gmiy5JrfTE+ptEBNoMXMriLHF9O1cJFYgjY/OtlHo0I/2eo+
         zuhfjiz7btJ1XjQE1EQBgfl2ssvWjMDUs8rL4p0y91IZ9NycjEjnQi84CKBMes7AhYLi
         WSazC9Xhpx2+iyS4N3j+aii0bYWTy4/+xvUzJtO9K6ZrLo04c25HIjD0mbluC4hQqgtU
         QhGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682383034; x=1684975034;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHR3/LN2j1zsFd+vHZpilKnpPMmVBsE4NTdgmjY6waM=;
        b=D9CDQNwEhFmA+SnBpNkbS7wh1w8yYbyA9UUm1i+IiyhZrb+UNNzgJwJcaGv9BE0bfq
         eyFFJ6CkzX3/fgqV1K17HVf51GjyFKDbikYy9TFAWpJu5lqQ2Hew7vQG2+joc7s9tYkO
         jvulrthdvl6QCObAw1E3yr+1HJcVYPtr1Re+cnd8U9ITq6N+W3DvK5XT5WPoWM6gEU66
         yc3Y+Ec2emq/v+S1R/nfHSXNXS8gkxLchts7Q0PwuDQANnHPdAnkOjS2y8oeGEeE5880
         w2alsLjFc2Qt5wdWTcooDPrXvJlcdsYg1+geyaqyOApiyfWkWmgzBPZ/A1AyTpQ55foV
         o7rA==
X-Gm-Message-State: AAQBX9cyZgq+yIDy1j46MD/0/bvK4qt3OqGDs14XYKmdfOAnabp8oL48
	sG+NELHGFsgTJm2HV1dJwtQ=
X-Google-Smtp-Source: AKy350b0m5/VBh+CSnw71qkmiWZtBD8z5PKu+OgUDeP0AQYb5QJd3Ri5eHles4ikwJ028doy0BWAVw==
X-Received: by 2002:a05:6a20:7da4:b0:f0:dedb:83b7 with SMTP id v36-20020a056a207da400b000f0dedb83b7mr19473521pzj.60.1682383033831;
        Mon, 24 Apr 2023 17:37:13 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id o1-20020a654581000000b0051fa7704c1asm6944624pgq.47.2023.04.24.17.37.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Apr 2023 17:37:13 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ZEceTNvdaLKJPTZ5@google.com>
Date: Mon, 24 Apr 2023 17:37:01 -0700
Cc: Anish Moorthy <amoorthy@google.com>,
 Peter Xu <peterx@redhat.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 maz@kernel.org,
 oliver.upton@linux.dev,
 James Houghton <jthoughton@google.com>,
 bgardon@google.com,
 dmatlack@google.com,
 ricarkol@google.com,
 kvm <kvm@vger.kernel.org>,
 kvmarm@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <5B22E759-8ED3-453E-84E1-2E6A69BE5D74@gmail.com>
References: <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n>
 <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <ZEboGH28IVKPZ2vo@google.com>
 <B6EEF84A-CCEA-44D7-B5AA-EA40073C81D4@gmail.com>
 <ZEceTNvdaLKJPTZ5@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3731.500.231)



> On Apr 24, 2023, at 5:26 PM, Sean Christopherson <seanjc@google.com> =
wrote:
>=20
> On Mon, Apr 24, 2023, Nadav Amit wrote:
>> Feel free to tell me to shut up, as it is none of my business, and I =
might be
>> missing a lot of context. Yet, it never stopped me before. :)
>>=20
>>> On Apr 24, 2023, at 1:35 PM, Sean Christopherson <seanjc@google.com> =
wrote:
>>>=20
>>> On Mon, Apr 24, 2023, Nadav Amit wrote:
>>>>=20
>>>>> On Apr 24, 2023, at 10:54 AM, Anish Moorthy <amoorthy@google.com> =
wrote:
>>>>> Sean did mention that he wanted KVM_CAP_MEMORY_FAULT_INFO in =
general,
>>>>> so I'm guessing (some version of) that will (eventually :) be =
merged
>>>>> in any case.
>>>>=20
>>>> It certainly not my call. But if you ask me, introducing a solution =
for
>>>> a concrete use-case that requires API changes/enhancements is not
>>>> guaranteed to be the best solution. It may be better first to fully
>>>> understand the existing overheads and agree that there is no =
alternative
>>>> cleaner and more general solution with similar performance.
>>>=20
>>> KVM already returns -EFAULT for these situations, the change I =
really want to land
>>> is to have KVM report detailed information about why the -EFAULT =
occurred.  I'll be
>>> happy to carry the code in KVM even if userspace never does anything =
beyond dumping
>>> the extra information on failures.
>>=20
>> I thought that the change is to inform on page-faults through a new =
interface
>> instead of the existing uffd-file-based one. There is already another =
interface
>> (signals) and I thought (but did not upstream) io-uring. You now =
suggest yet
>> another one.
>=20
> There are two capabilities proposed in this series: one to provide =
more information
> when KVM encounters a fault it can't resolve, and another to tell KVM =
to kick out
> to userspace instead of attempting to resolve a fault when a given =
address couldn't
> be resolved with fast gup.  I'm talking purely about the first one: =
providing more
> information when KVM exits.
>=20
> As for the second, my plan is to try and stay out of the way and let =
people that
> actually deal with the userspace side of things settle on an approach. =
 =46rom the
> KVM side, supporting the "don't wait to resolve faults" flag is quite =
simple so
> long as KVM punts the heavy lifting to userspace, e.g. identifying =
_why_ the address
> isn't mapped with the appropriate permissions.

Thanks for your kind and detailed reply. I removed the parts that I =
understand.

As you might guess, I focus on the second part, which you leave for =
others. The
interactions between two page-fault reporting mechanisms is not trivial, =
and it
is already not fully correct.

I understand the approach that Anish prefers is to do something that is =
tailored
for KVM, but I am not sure it is the best thing.

