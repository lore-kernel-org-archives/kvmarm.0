Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54201990B
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 17:24:24 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-53fb4ee9ba1so446766a12.3
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 10:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686245064; x=1688837064;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XL9bsC//gXuc7C5OzuzU0d50fzWgPEd1BsIEsVnXnhE=;
        b=rYGyLuoP4Kkzt9M/GDqS8KCUwQPNzaazOWhKXdvuy9QlWEmPpWhs5o3gix5PYVRmT4
         GswcLn8C9ttTFBwcTM25aR+WPf7vjE0p1GoFzBUfuSCG6/Lek8DEGC3tnYva6lOQlXGj
         YE7MGgIwcsMX7EVCTp+kt5R8DER2vI/M2w4peW7MiqE3OdQlkasL55NUG5Qvwk7aFI4K
         hLYFPhA/cOh56eXHQfFAvtsT+TSRPDvSsJfxabl/RXONG3IfWYaEAVDw6pORrDnPT9DA
         DDDXAQErQd/0Re0Ey4l2G/UR6E/ndZf2lP1yO/Jvny0o8S0sU+dg0K3QRCfLkERafB6e
         +q6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686245064; x=1688837064;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XL9bsC//gXuc7C5OzuzU0d50fzWgPEd1BsIEsVnXnhE=;
        b=dbY4jKhwe7WaafA8QqI4pHCIYjdJP6oB8KaIY1slhKwllMEek5m8HqwHm1X77fRX1C
         mP07YHJTGOPJobZRRcB+o9bHWSJ0XB4bfHriMFSs8N3FBCgibJ1M/3zoHFlQgBTz4grI
         xWgF9L2bBjXMIy/hDvfxekUq8OaIndTujq9a789Ol56H/MyjNx5r+lryh2Jt8jlRDoPt
         8yRJX/iJhFRO5GEnjId7fHmhfWhtcKoo130+8VTP+EfQK758bqnHJVri7dfqOr2QqmAH
         g04RsPTIpQxxOja71G4piOuYB+1EHoxaAFcYOuo4jhV7EQQD5xAb+yx35g16BjkdwhVG
         A/BQ==
X-Gm-Message-State: AC+VfDzAn+571XCNAw1SE7wxDrP/Us3XYURDonzRxUVtcQw3snblW4nJ
	rMFGmwyaOceDsvyzGG3Bo/s=
X-Google-Smtp-Source: ACHHUZ6CzWfNWAROq8fvBWQOGQH9Net4T3vU6TxOvUP/DQ2oGfEPtYQn+AO91Tgkyn6pWYg7r/FU8g==
X-Received: by 2002:a05:6a20:3944:b0:106:c9b7:c932 with SMTP id r4-20020a056a20394400b00106c9b7c932mr4999752pzg.1.1686245063924;
        Thu, 08 Jun 2023 10:24:23 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.113])
        by smtp.gmail.com with ESMTPSA id d3-20020aa78143000000b0064d681c753csm1352967pfn.40.2023.06.08.10.24.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2023 10:24:23 -0700 (PDT)
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
In-Reply-To: <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
Date: Thu, 8 Jun 2023 10:24:11 -0700
Cc: kvm@vger.kernel.org,
 kvmarm@lists.linux.dev,
 andrew.jones@linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>,
 alexandru.elisei@arm.com,
 ricarkol@google.com,
 shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <BB231709-0C9D-4085-ABFA-B6C37EF537CA@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-13-nikos.nikoleris@arm.com>
 <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
X-Mailer: Apple Mail (2.3731.600.7)



> On Jun 8, 2023, at 10:18 AM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>=20
> On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:
>=20
>>=20
>> +static void uart0_init_acpi(void)
>> +{
>> + struct spcr_descriptor *spcr =3D =
find_acpi_table_addr(SPCR_SIGNATURE);
>> +
>> + assert_msg(spcr, "Unable to find ACPI SPCR");
>> + uart0_base =3D ioremap(spcr->serial_port.address, =
spcr->serial_port.bit_width);
>> +}
>=20
> Is it possible as a fallback, is SPCR is not available, to =
UART_EARLY_BASE as
> address and bit_width as bit-width?
>=20
> I would appreciate it, since it would help my setup.
>=20

Ugh - typo, 8 as bit-width for the fallback (ioremap with these =
parameters to
make my request clear).

