Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9535A2F2D
	for <kvmarm@lists.linux.dev>; Tue, 11 Apr 2023 08:28:18 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id j1so10656403wrb.0
        for <kvmarm@lists.linux.dev>; Tue, 11 Apr 2023 01:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681201697; x=1683793697;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQ0drIWzBl8+TPE9EFtuKvjJ26MgcK8N50RWv3O5VHo=;
        b=ldfLULADu6snRA2bB6QD6/b5ZvdowkwKJ9mCRSCCor0CJsRGit0mkSUUgRNbHxI+zW
         S8oBv3MHt8hnRiHrJ99DyAaUKGIX7y3LM9tGoNu6/LbGOZ6/B5F/IVxaZzN4ZwA0VdlD
         NhVYVo0cdvq6D4nwF1coVzR5MDIyDeDV1cRwSohYBOpPeQr/OsukVL6jHy2rN8FSKk6U
         /EQOt7CJYz+bPZXdpu20FGaVVDt8k/ccDfrSS4zcupundRRjGiEfRuSJUTuhC/caH8Fm
         QCmEMARYZSiUeHq1Y5bbztc9Z4xNxOkk96v5v1+Hrt8EpArblKBOFERxzbQt78pohk0x
         eTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681201697; x=1683793697;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MQ0drIWzBl8+TPE9EFtuKvjJ26MgcK8N50RWv3O5VHo=;
        b=Ul7Q6TCVyU9fDVVNnZ+waMI+FhGhGWDhHxbjb7pSkgwgGTX0GGdI4Nid1j3vBIqtI4
         dAUF8OKMf7nsDwb6qbEjG91e2bUVoSQ5EY6BHGtrwwCeuPqZ3+O/Z9OvBfOUMhnsh5gA
         O3KcUpptLaB88KenzAPLRHZBFOFblKMaI9KWnUJLL2UZKpWBGXLUXllUCBPu7ek/vjmT
         CzZdWdnHzQzBJOWrwTcryy7U/Xz1pOn2/k+4991PtT0gCjKw0WsjKuFNWQ/dUxt3/Ihm
         J34EWrmHQgYpNhYHEu3fJIW2iY1hHafraLJHGA5OZUNH+d+8fSsIRElC8AlULUq3k0Wo
         09rg==
X-Gm-Message-State: AAQBX9fQY4lTAJjKbPsDZ7G/IjzHnTK9s7H1h1MhUuYZsxo/X3ICjSz8
	SZXNNnd1j4TOS+S6/xY7C8vlVg==
X-Google-Smtp-Source: AKy350ZqH49K+BAAmm735ZwwqN+arqWQEaqXtjDVehw3IW1uBc6FBRptmMKZQ89c1AY3FMzFcvegGw==
X-Received: by 2002:a5d:4204:0:b0:2cf:f04b:fb23 with SMTP id n4-20020a5d4204000000b002cff04bfb23mr9173789wrq.59.1681201695275;
        Tue, 11 Apr 2023 01:28:15 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id m13-20020a5d4a0d000000b002efebaf3571sm7327060wrq.64.2023.04.11.01.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 01:28:14 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
	by zen.linaroharston (Postfix) with ESMTP id 732391FFB7;
	Tue, 11 Apr 2023 09:28:14 +0100 (BST)
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230307112845.452053-5-alex.bennee@linaro.org>
 <20230321150220.mfrvgxg3ebju5e6k@orel>
User-agent: mu4e 1.10.0; emacs 29.0.90
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, kvmarm@lists.linux.dev, qemu-arm@nongnu.org, Mark
 Rutland <mark.rutland@arm.com>
Subject: Re: [kvm-unit-tests PATCH v10 4/7] arm/tlbflush-code: TLB flush
 during code execution
Date: Tue, 11 Apr 2023 09:26:56 +0100
In-reply-to: <20230321150220.mfrvgxg3ebju5e6k@orel>
Message-ID: <87ile2rffl.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Andrew Jones <andrew.jones@linux.dev> writes:

> On Tue, Mar 07, 2023 at 11:28:42AM +0000, Alex Benn=C3=A9e wrote:
>> This adds a fairly brain dead torture test for TLB flushes intended
>> for stressing the MTTCG QEMU build. It takes the usual -smp option for
>> multiple CPUs.
>>=20
<snip>
>
> BTW, have you tried running these tests as standalone? Since they're
> 'nodefault' it'd be good if they work that way.

It works but I couldn't get it to skip pass the nodefault check
automaticaly:

  env run_all_tests=3D1 QEMU=3D$HOME/lsrc/qemu.git/builds/arm.all/qemu-syst=
em-aarch64 ./tests/tcg.computed=20
  BUILD_HEAD=3Dc9cf6e90
  Test marked not to be run by default, are you sure (y/N)?

>
>> +file =3D tlbflush-code.flat
>> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
>> +groups =3D nodefault mttcg
>> +
>> +[tlbflush-code::page_other]
>> +file =3D tlbflush-code.flat
>> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
>> +extra_params =3D -append 'page'
>> +groups =3D nodefault mttcg
>> +
>> +[tlbflush-code::all_self]
>> +file =3D tlbflush-code.flat
>> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
>> +extra_params =3D -append 'self'
>> +groups =3D nodefault mttcg
>> +
>> +[tlbflush-code::page_self]
>> +file =3D tlbflush-code.flat
>> +smp =3D $(($MAX_SMP>4?4:$MAX_SMP))
>> +extra_params =3D -append 'page self'
>> +groups =3D nodefault mttcg
>> +
>> --=20
>> 2.39.2
>>
>
> Thanks,
> drew


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
