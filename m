Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA06F19E44
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 17:19:07 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b24ff03400so5417255ad.3
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 10:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686244747; x=1688836747;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xn4z4bAdLLnUlD27MUprwNeTY3jrE96t84qZ964f9xY=;
        b=A7nR4+SOsuhrP4/mJAD4mWHu+cMDM2QkXpBSOkdYLrelvxn+IvdhuS6cxi5mB4yiam
         ogbRfUtaU9t3ZBBMl/KXuDl85TOjXMPFwZHjC7A/0q2tY6RiF0KYwJ+kxQbJJ9JQa4/g
         N7yY2aL1r8T5znpL37Uev3UBg2SnMwqQwf2rvoW72nmShobFz5deiPceOT/4YkJA4Bcu
         JsdfiA4vZhbx43LJOe/blRxtHReFCPL/+/M0oKkBarN6bNOATxsuCteuMZUdjdDPTikD
         qrqcaff/skuy4qFqDouHZP41H9lPYRm654HcGpZO27UthFcqYPc6vZ6J88FbrCDT+o0D
         NUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686244747; x=1688836747;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xn4z4bAdLLnUlD27MUprwNeTY3jrE96t84qZ964f9xY=;
        b=IjrxFIQNrc9YtmWggCgTVDu9XBksmnAxelBUbFy0+YE22xVYphQsUqevDQTH8rJRF8
         MvnM4JRDjCokQCdd7u3BwspDu9IEAtmTBs50+UE1vNhCMtASaeiPJW8LFYDEM4nvYC+f
         hSft69mHyTJNtJkFF5tuRV1q9sRFrgntixMj8pf1l7X4cQTbsCffOs0y6mCjuMRXLOn0
         0lf4cghgLoWSvTSzGMTAYp7MZP6eLXx65BCIL0QP75Vc0DdkX2vMGtnj5o0HVzdyRtqI
         9Do1LVY+U0+K6gn/H5ps4SvLCM3n8N9pOQRIBBJ0EQLRFLurfw2sRykN09PqVRPqejZJ
         a00w==
X-Gm-Message-State: AC+VfDyXQtHH+aNQkk0SdQ3V+VI4pssvLwIHteYaE3sLbcNSdKhb/n/v
	Zcjl02YuxqUfZ8ZoajVm19VSsSVzuuc=
X-Google-Smtp-Source: ACHHUZ7adI2YgI6vjLXTvVu6AZpT3Ndk7WpCL9qLv9m7+wBNFY63OV6LQ4FpJW8k1QuodPQZnNrIow==
X-Received: by 2002:a17:902:b20e:b0:1b1:9218:6bf9 with SMTP id t14-20020a170902b20e00b001b192186bf9mr5547527plr.43.1686244746610;
        Thu, 08 Jun 2023 10:19:06 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.113])
        by smtp.gmail.com with ESMTPSA id j3-20020a17090276c300b001ac7af58b66sm1674083plt.224.2023.06.08.10.19.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2023 10:19:06 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 12/32] arm64: Add support for
 discovering the UART through ACPI
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230530160924.82158-13-nikos.nikoleris@arm.com>
Date: Thu, 8 Jun 2023 10:18:54 -0700
Cc: kvm@vger.kernel.org,
 kvmarm@lists.linux.dev,
 andrew.jones@linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>,
 alexandru.elisei@arm.com,
 ricarkol@google.com,
 shahuang@redhat.com,
 Andrew Jones <drjones@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-13-nikos.nikoleris@arm.com>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
X-Mailer: Apple Mail (2.3731.600.7)


On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:

>=20
> +static void uart0_init_acpi(void)
> +{
> +	struct spcr_descriptor *spcr =3D =
find_acpi_table_addr(SPCR_SIGNATURE);
> +
> +	assert_msg(spcr, "Unable to find ACPI SPCR");
> +	uart0_base =3D ioremap(spcr->serial_port.address, =
spcr->serial_port.bit_width);
> +}

Is it possible as a fallback, is SPCR is not available, to =
UART_EARLY_BASE as
address and bit_width as bit-width?

I would appreciate it, since it would help my setup.

