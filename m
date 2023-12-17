Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D79EA9
	for <kvmarm@lists.linux.dev>; Sun, 17 Dec 2023 02:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l8IEuVEC"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5906eac104bso1447377eaf.2
        for <kvmarm@lists.linux.dev>; Sat, 16 Dec 2023 18:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702779495; x=1703384295; darn=lists.linux.dev;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=OFl8kjpw91XelbaLp/NqZrQDKjPZSUtARdmSUPQXSX8=;
        b=l8IEuVECGqxIg8pNAX4Jm4JGOxPwKQmnK6USnESWLsbqQw7zBEMgsqwDrNbCnomETS
         y6Tl5HAwPg00siXOAwxT7+zSw4S9IUl478Wuhx3DHrhPU+BgyEOS4k6I+ugaBM0Likx8
         flkaS2yF5QB6oOTMIQD6Ul3ecFLjm1pbYrm7GaqqOKIOA4daOfjyejpDdSxfNDiY/tq4
         9a7wtGUGn+6+Was9OhIEBX0W8C8Ai/HnBLswB0yQovjJxKXIzJHsJtMW6UwH7N1vy+bz
         9sExolIRK2cgcYDuv8wNXDGz6m7IWWHTlAyguloHhU2062APCJBqMixLPqgYfDJx74ax
         DcYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702779495; x=1703384295;
        h=mime-version:message-id:date:in-reply-to:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFl8kjpw91XelbaLp/NqZrQDKjPZSUtARdmSUPQXSX8=;
        b=Rj+VlSHdfEsQSx7BZhaunmiomYO/XO3vlrMfgJHMcEa3n2+E9y23ouVNFQPiteklQp
         hXTJhqc8AbyTARm7N+6ya9BH3kE1rM2sK+363Ayd78kU4UjG1Pv2AYrqP2WSkJssw/vG
         +f3UayxSCCCrVJWBtcxF+TrSeT2i94QJshXlsAECfkz1PKZSeLcM44ZhhGEBI6VPkVXk
         tw8UkFcS/+i9P3XdaJaGAw3m+qQYbngMmTyuG7SjssFAHww8e6T+GRzPuyHx9cfmB5Rg
         7aAodD8RpKb91sfSyAg6USKgv/4RBzOlCIHxzSfSU6OFy7lLdAaEPWSp2rC5dApR58cv
         G7eQ==
X-Gm-Message-State: AOJu0YymPXAKqpgTNwJPcdOiZF3nN1pkfIOf9VT74f2Fr2TbboPylNO7
	tra1jqILfLUjZSg+zgiYTPohxw==
X-Google-Smtp-Source: AGHT+IF+rykhjl/vJMlMFtG1M64I68Xtmq2p6wjQt8Jp7El542Y7P1lc23SbwSwdEGVtxnixp9/AeQ==
X-Received: by 2002:a05:6808:3a09:b0:3b9:e828:816 with SMTP id gr9-20020a0568083a0900b003b9e8280816mr20647236oib.48.1702779495498;
        Sat, 16 Dec 2023 18:18:15 -0800 (PST)
Received: from localhost ([2804:14d:7e39:8470:a30f:cc0e:7239:16c3])
        by smtp.gmail.com with ESMTPSA id ja11-20020a170902efcb00b001d39f6edd54sm1453638plb.84.2023.12.16.18.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 18:18:14 -0800 (PST)
References: <20231122-arm64-gcs-v7-0-201c483bd775@kernel.org>
 <20231122-arm64-gcs-v7-34-201c483bd775@kernel.org>
 <875y1089i4.fsf@linaro.org>
 <485b6454-135c-4dd4-b38e-8fb8a02779cd@sirena.org.uk>
User-agent: mu4e 1.10.8; emacs 29.1
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton
 <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, Oleg
 Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees
 Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, "Rick P.
 Edgecombe" <rick.p.edgecombe@intel.com>, Deepak Gupta
 <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, Szabolcs Nagy
 <Szabolcs.Nagy@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Florian Weimer <fweimer@redhat.com>, Christian
 Brauner <brauner@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v7 34/39] kselftest/arm64: Add a GCS test program built
 with the system libc
In-reply-to: <485b6454-135c-4dd4-b38e-8fb8a02779cd@sirena.org.uk>
Date: Sat, 16 Dec 2023 23:18:13 -0300
Message-ID: <871qbl7esa.fsf@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Mark Brown <broonie@kernel.org> writes:

>> Also, it's strange that the tests defined after map_gcs.stack_overflow
>> don't run when I execute this test program. I'm doing:
>
>> $ ./run_kselftest.sh -t arm64:libc-gcs
>
>> I.e., these tests aren't being run in my FVP:
>
>> > +FIXTURE_VARIANT_ADD(map_invalid_gcs, too_small)
>> > +FIXTURE_VARIANT_ADD(map_invalid_gcs, unligned_1)
>> > +FIXTURE_VARIANT_ADD(map_invalid_gcs, unligned_2)
>> > +FIXTURE_VARIANT_ADD(map_invalid_gcs, unligned_3)
>> > +FIXTURE_VARIANT_ADD(map_invalid_gcs, unligned_4)
>> > +FIXTURE_VARIANT_ADD(map_invalid_gcs, unligned_5)
>> > +FIXTURE_VARIANT_ADD(map_invalid_gcs, unligned_6)
>> > +FIXTURE_VARIANT_ADD(map_invalid_gcs, unligned_7)
>> > +TEST_F(map_invalid_gcs, do_map)
>> > +FIXTURE_VARIANT_ADD(invalid_mprotect, exec)
>> > +FIXTURE_VARIANT_ADD(invalid_mprotect, bti)
>> > +FIXTURE_VARIANT_ADD(invalid_mprotect, exec_bti)
>> > +TEST_F(invalid_mprotect, do_map)
>> > +TEST_F(invalid_mprotect, do_map_read)
>
> I'm seeing all of those appearing.  I'm not sure what to say there -
> that's all kselftest framework stuff, I'd expect the framework to say
> something about what it's doing if it decides to skip and I can't think
> why it would decide to skip.

Thanks. I'll poke some more to see if I can figure out what's going on.

-- 
Thiago
