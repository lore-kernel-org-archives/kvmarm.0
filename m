From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5 07/17] arm64: add basic pointer authentication support
Date: Fri, 19 Oct 2018 09:05:57 -0700
Message-ID: <CAGXu5jK8OK+430FQtztwVD8B95_SCjTWoysZXBdkZaDeSiV+ow@mail.gmail.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-8-kristina.martsenko@arm.com> <20181019111542.6wrvjguirglzg7vg@mbp>
 <20181019112404.GD14246@arm.com> <CAGXu5j+2axuzPJji_eCvMZDiPvrPsP3kAnG0CY_rsL5c=uFQFA@mail.gmail.com>
 <20181019154948.GD16771@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019154948.GD16771@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Rutland <mark.rutland@arm.com>, linux-arch <linux-arch@vger.kernel.org>, Andrew Jones <drjones@redhat.com>, Jacob Bramley <jacob.bramley@arm.com>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Adam Wallis <awallis@codeaurora.org>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <Amit.Kachhap@arm.com>, Dave P Martin <Dave.Martin@arm.com>, LKML <linux-kernel@vger.kernel.org>, Cyrill
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 19, 2018 at 8:49 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Oct 19, 2018 at 08:36:45AM -0700, Kees Cook wrote:
>> On Fri, Oct 19, 2018 at 4:24 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > FWIW: I think we should be entertaining a prctl() interface to use a new
>> > key on a per-thread basis. Obviously, this would need to be used with care
>> > (e.g. you'd fork(); use the prctl() and then you'd better not return from
>> > the calling function!).
>> >
>> > Assuming we want this (Kees -- I was under the impression that everything in
>> > Android would end up with the same key otherwise?), then the question is
>> > do we want:
>> >
>> >   - prctl() get/set operations for the key, or
>> >   - prctl() set_random_key operation, or
>> >   - both of the above?
>> >
>> > Part of the answer to that may lie in the requirements of CRIU, where I
>> > strongly suspect they need explicit get/set operations, although these
>> > could be gated on CONFIG_CHECKPOINT_RESTORE=y.
>>
>> Oh CRIU. Yikes. I'd like the get/set to be gated by the CONFIG, yes.
>> No reason to allow explicit access to the key (and selected algo) if
>> we don't have to.
>
> Makes sense.
>
>> As for per-thread or not, having a "pick a new key now" prctl() sounds
>> good, but I'd like to have an eye toward having it just be "automatic"
>> on clone().
>
> I thought about that too, but we're out of clone() flags afaict and there's
> no arch hook in there. We could add yet another clone syscall, but yuck (and
> I reckon viro would kill us).
>
> Or are you saying that we could infer the behaviour from the existing set
> of flags?

I mean if it's starting a new thread, it should get a new key
automatically, just like the ssp canary happens in dup_task_struct().

(Or did I miss some context for why that's not possible?)

-Kees

-- 
Kees Cook
Pixel Security
